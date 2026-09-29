# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class Api::V1::AdminAuthenticationTest < ActionDispatch::IntegrationTest
  def setup
    @site = create :site
    @user = create :user, site: @site
  end

  def test_request_without_token_is_unauthorized
    get(api_v1_categories_path, headers:)
    assert_response :unauthorized
    assert_equal I18n.t("session.could_not_auth"), response_json["error"]
  end

  def test_request_with_blank_token_is_unauthorized_even_if_a_user_has_no_token
    @user.update_column(:authentication_token, nil)
    get(api_v1_categories_path, headers: headers.merge("X-User-Token": ""))
    assert_response :unauthorized
  end

  def test_request_with_unknown_token_is_unauthorized
    get(api_v1_categories_path, headers: headers.merge("X-User-Token": "nope"))
    assert_response :unauthorized
  end

  def test_token_of_user_from_another_site_is_unauthorized
    other = create :user, site: create(:site)
    Site.stub(:first, @site) do
      get(api_v1_categories_path, headers: auth_headers(other))
    end
    assert_response :unauthorized
  end

  def test_request_with_valid_token_succeeds
    get(api_v1_categories_path, headers: auth_headers(@user))
    assert_response :success
  end
end
