# frozen_string_literal: true

class Api::V1::BaseController < ApplicationController
  include AdminAuthenticatable

  private

    def auth_response(user)
      {
        user: user.slice(:id, :first_name, :last_name, :email),
        authentication_token: user.authentication_token
      }
    end
end
