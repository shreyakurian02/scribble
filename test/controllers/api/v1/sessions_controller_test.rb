# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @site = create :site
    @user = create :user, site: @site, password: "welcome1"
  end

  def test_should_sign_in_with_valid_credentials
    post(api_v1_session_path, params: { login: { email: @user.email, password: "welcome1" } }, headers:)
    assert_response :success
    assert_equal @user.authentication_token, response_json["authentication_token"]
    assert_equal @user.email, response_json["user"]["email"]
  end

  def test_email_is_case_insensitive
    post(api_v1_session_path, params: { login: { email: @user.email.upcase, password: "welcome1" } }, headers:)
    assert_response :success
  end

  def test_shouldnt_sign_in_with_wrong_password_or_unknown_email
    [[@user.email, "wrong-pass"], ["nobody@example.com", "welcome1"]].each do |email, password|
      post(api_v1_session_path, params: { login: { email:, password: } }, headers:)
      assert_response :unauthorized
      assert_equal I18n.t("session.incorrect_credentials"), response_json["error"]
    end
  end

  def test_shouldnt_sign_in_a_user_from_another_site
    other_site_user = create :user, site: create(:site), password: "welcome1"
    Site.stub(:first, @site) do
      post(api_v1_session_path, params: { login: { email: other_site_user.email, password: "welcome1" } }, headers:)
    end
    assert_response :unauthorized
  end

  def test_sign_out_invalidates_the_token
    old_token = @user.authentication_token
    delete(api_v1_session_path, headers: auth_headers(@user))
    assert_response :success
    assert_equal I18n.t("session.signed_out"), response_json["notice"]
    assert_not_equal old_token, @user.reload.authentication_token

    get(api_v1_categories_path, headers: headers.merge("X-User-Token": old_token))
    assert_response :unauthorized
  end

  def test_sign_out_without_token_is_unauthorized
    delete(api_v1_session_path, headers:)
    assert_response :unauthorized
  end
end
