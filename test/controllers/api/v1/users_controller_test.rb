# frozen_string_literal: true

require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @site = create :site
  end

  def test_should_sign_up_with_valid_params
    assert_difference "@site.users.count", 1 do
      post(api_v1_signup_path, params: { user: signup_params }, headers:)
    end
    assert_response :success
    user = @site.users.find_by(email: "new@example.com")
    assert_equal user.authentication_token, response_json["authentication_token"]
    assert_equal user.id, response_json["user"]["id"]
  end

  def test_shouldnt_sign_up_with_short_password
    assert_no_difference "User.count" do
      post(
        api_v1_signup_path, params: { user: signup_params(password: "12345", password_confirmation: "12345") },
        headers:)
    end
    assert_response :unprocessable_entity
    assert_includes response_json["error"], "Password is too short"
  end

  def test_shouldnt_sign_up_with_mismatched_confirmation
    assert_no_difference "User.count" do
      post(api_v1_signup_path, params: { user: signup_params(password_confirmation: "other12") }, headers:)
    end
    assert_response :unprocessable_entity
    assert_includes response_json["error"], "Password confirmation doesn't match Password"
  end

  def test_shouldnt_sign_up_with_duplicate_email_in_same_site
    create :user, site: @site, email: "new@example.com"
    assert_no_difference "User.count" do
      post(api_v1_signup_path, params: { user: signup_params(email: "NEW@example.com") }, headers:)
    end
    assert_response :unprocessable_entity
    assert_includes response_json["error"], "Email has already been taken"
  end

  private

    def signup_params(overrides = {})
      {
        first_name: "New", last_name: "User", email: "new@example.com",
        password: "welcome1", password_confirmation: "welcome1"
      }.merge(overrides)
    end
end
