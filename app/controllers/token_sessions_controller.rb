class TokenSessionsController < InheritedResources::Base
  protect_from_forgery with: :null_session
  respond_to :json
  actions :create

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.valid_password?(params[:password])
      token = AuthenticationToken.find_or_create_for(@user)

      response = { json: { user_id: @user.id, auth_token: token.auth_token } }
    else
      response = { json: { errors: "invalid_credentials" }, status: :unauthorized }
    end

    respond_to do |format|
      format.json { render(response) }
    end
  end
end
