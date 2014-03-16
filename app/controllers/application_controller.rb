class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_by_token

  rescue_from ActiveRecord::RecordNotFound do
    case request.format
    when "json"
      render nothing: true, status: :not_found
    when "html"
      render "404.html"
    end
  end

  private
  def authenticate_by_token
    token_value = request.headers['X-Auth-Token'] || params[:auth_token]
    if token_value.present? && token = AuthenticationToken.active.find_by_auth_token(token_value)
      sign_in(:user, token.user)
    end
  end
end
