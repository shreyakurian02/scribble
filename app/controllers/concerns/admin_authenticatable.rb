# frozen_string_literal: true

module AdminAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user_using_x_auth_token
  end

  private

    def current_user
      @_current_user
    end

    def authenticate_user_using_x_auth_token
      token = request.headers["X-User-Token"].presence
      @_current_user = token && @site.users.find_by(authentication_token: token)
      render_error(t("session.could_not_auth"), :unauthorized) unless @_current_user
    end
end
