class ProjectsController < ApplicationController
  before_action :restrict_access, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_entity, only: [:edit, :update, :destroy]

  layout 'admin', only: [:new, :edit]

  # get /projects
  def index
    @collection = Project.page_for_visitors(current_page)
  end

  # get /projects/new
  def new
    @entity = Project.new
  end

  # post /projects
  def create
    @entity = Project.new(entity_parameters)
    if @entity.save
      next_page = admin_project_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to next_page }
        format.json { render json: { links: { self: next_page } } }
        format.js { render js: "document.location.href = '#{next_page}'" }
      end
    else
      render :new, status: :bad_request
    end
  end

  # get /projects/:id
  def show
    @entity = Project.find_by(slug: params[:id], visible: true)
    if @entity.nil?
      handle_http_404("Cannot find non-deleted project #{params[:id]}")
    end
  end

  # get /projects/:id/edit
  def edit
  end

  # patch /projects/:id
  def update
    if @entity.update(entity_parameters)
      next_page = admin_project_path(@entity.id)
      respond_to do |format|
        format.html { redirect_to next_page }
        format.json { render json: { links: { self: next_page } } }
        format.js { render js: "document.location.href = '#{next_page}'" }
      end
    else
      render :edit, status: :bad_request
    end
  end

  # delete /projects/:id
  def destroy
    if @entity.destroy
      flash[:notice] = t('projects.destroy.success')
    end
    redirect_to admin_projects_path
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

  def entity_parameters
    params.require(:project).permit(Project.entity_parameters)
  end
end
