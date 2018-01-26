class Admin::ProjectsController < AdminController
  include ToggleableEntity
  include EntityPriority

  before_action :set_entity, except: [:index]

  # get /admin/projects
  def index
    @collection = Project.page_for_administration(current_page)
  end

  # get /admin/projects/:id
  def show
  end

  private

  def set_entity
    @entity = Project.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find project')
    end
  end

  def restrict_access
    require_privilege :portfolio_manager
  end
end
