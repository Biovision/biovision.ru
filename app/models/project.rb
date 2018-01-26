class Project < ApplicationRecord
  include RequiredUniqueName
  include RequiredUniqueSlug
  include Toggleable

  PER_PAGE          = 20
  PRIORITY_RANGE    = (1..32767)
  NAME_LIMIT        = 100
  LEAD_LIMIT        = 250
  URL_LIMIT         = 250
  IMAGE_ALT_LIMIT   = 250
  DESCRIPTION_LIMIT = 50000
  SLUG_LIMIT        = 100
  SLUG_PATTERN      = /\A[a-z][-0-9a-z]*[0-9a-z]\z/i
  SLUG_PATTERN_HTML = /^[a-z][-0-9a-z]*[0-9a-z]$/i

  toggleable :visible, :highlight

  mount_uploader :image, ProjectImageUploader

  after_initialize { self.uuid = SecureRandom.uuid if uuid.nil? }
  after_initialize :set_next_priority
  before_validation { self.slug = Canonizer.transliterate(title.to_s) if slug.blank? }
  before_validation { self.slug = slug.downcase }
  before_validation :normalize_priority

  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_format_of :slug, with: SLUG_PATTERN
  validates_length_of :lead, maximum: LEAD_LIMIT
  validates_length_of :description, maximum: DESCRIPTION_LIMIT
  validates_length_of :url, maximum: URL_LIMIT
  validates_length_of :image_alt_text, maximum: IMAGE_ALT_LIMIT

  scope :ordered_by_priority, -> { order('priority asc') }
  scope :visible, -> { where(visible: true) }
  scope :highlighted, -> { where(highlight: true) }
  scope :list_for_visitors, -> { visible.ordered_by_priority }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    ordered_by_priority.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitors(page = 1)
    list_for_visitors.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(visible highlight name slug url image image_alt_text lead description)
  end

  # @param [Integer] delta
  def change_priority(delta)
    new_priority = priority + delta
    criteria     = { priority: new_priority }
    adjacent     = self.class.find_by(criteria)
    if adjacent.is_a?(self.class) && (adjacent.id != id)
      adjacent.update!(priority: priority)
    end
    self.update(priority: new_priority)

    self.class.ordered_by_priority.map { |e| [e.id, e.priority] }.to_h
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = self.class.maximum(:priority).to_i + 1
    end
  end

  def normalize_priority
    self.priority = PRIORITY_RANGE.first if priority < PRIORITY_RANGE.first
    self.priority = PRIORITY_RANGE.last if priority > PRIORITY_RANGE.last
  end
end
