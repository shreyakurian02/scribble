# frozen_string_literal: true

class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user_using_x_auth_token, only: :create

  def create
    user = @site.users.find_by(email: login_params[:email])
    if user&.authenticate(login_params[:password])
      render_json(auth_response(user))
    else
      render_error(t("session.incorrect_credentials"), :unauthorized)
    end
  end

  def destroy
    current_user.regenerate_authentication_token
    render_notice(t("session.signed_out"))
  end

  private

    def login_params
      params.require(:login).permit(:email, :password)
    end
end
