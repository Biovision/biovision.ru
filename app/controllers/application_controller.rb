class ApplicationController < ActionController::Base
  class UnauthorizedException < Exception
  end

  class ForbiddenException < Exception
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_page, :param_from_request

  # Получить текущую страницу из запроса
  #
  # @return [Integer]
  def current_page
    @current_page ||= (params[:page] || 1).to_s.to_i.abs
  end

  # Получить параметр из запроса и нормализовать его
  #
  # Приводит параметр к строке в UTF-8 и удаляет недействительные в UTF-8 символы
  #
  # @param [Symbol] parameter
  # @return [String]
  def param_from_request(parameter)
    params[parameter].to_s.encode('UTF-8', 'UTF-8', invalid: :replace, replace: '')
  end
end
