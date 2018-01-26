module ProjectsHelper
  # @param [Project] entity
  # @param [String] text
  def admin_project_link(entity, text = entity.name)
    link_to(text, admin_project_path(entity.id))
  end

  # @param [Project] entity
  # @param [String] text
  # @param [Hash] options
  def project_link(entity, text = entity.name, options = {})
    link_to(text, project_path(entity.slug), options)
  end

  # Project image preview for displaying in "administrative" lists
  #
  # @param [Project] entity
  def project_image_preview(entity)
    return '' if entity.image.blank?

    versions = "#{entity.image.preview_2x.url} 2x"
    image_tag(entity.image.preview.url, alt: entity.name, srcset: versions)
  end

  # Small post image for displaying in lists of posts and feeds
  #
  # @param [Project] entity
  # @param [Hash] add_options
  def project_image_small(entity, add_options = {})
    return '' if entity.image.blank?

    alt_text = entity.image_alt_text.to_s
    versions = "#{entity.image.medium.url} 2x"
    options  = { alt: alt_text, srcset: versions }.merge(add_options)
    image_tag(entity.image.small.url, options)
  end

  # Medium post image for displaying on post page
  #
  # @param [Project] entity
  # @param [Hash] add_options
  def project_image_medium(entity, add_options = {})
    return '' if entity.image.blank?

    alt_text = entity.image_alt_text.to_s
    versions = "#{entity.image.big.url} 2x"
    options  = { alt: alt_text, srcset: versions }.merge(add_options)
    image_tag(entity.image.medium.url, options)
  end
end
