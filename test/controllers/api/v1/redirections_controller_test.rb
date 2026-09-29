# frozen_string_literal: true

require "test_helper"

class Api::V1::RedirectionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @site = create :site
    @current_user = create :user, site: @site
    @redirection = create :redirection, site: @site
  end

  def test_should_list_all_redirections
    create_list :redirection, 5, site: @site
    get(api_v1_redirections_path, headers: auth_headers(@current_user))
    assert_response :success
    assert_equal @site.redirections.length, response_json["redirections"].length
  end

  def test_should_create_valid_redirection
    assert_difference "@site.redirections.size" do
      post(
        api_v1_redirections_path, params: redirection_params({ site_id: @site.id }),
        headers: auth_headers(@current_user))
      assert_response :success
    end

    assert_equal I18n.t("successfully_created", entity: "Redirection"), response_json["notice"]
  end

  def test_should_update_valid_redirection
    new_to_path = Faker::Internet.url
    put(
      api_v1_redirection_path(@redirection.id), params: redirection_params({ to_path: new_to_path }),
      headers: auth_headers(@current_user))
    assert_response :success
    assert_equal I18n.t("successfully_updated", entity: "Redirection"), response_json["notice"]
    assert_equal new_to_path, @redirection.reload.to_path
  end

  def test_shouldnt_update_redirection_with_invalid_params
    existing_to_path = @redirection.to_path
    put(
      api_v1_redirection_path(@redirection.id), params: redirection_params({ to_path: "" }),
      headers: auth_headers(@current_user))
    assert_response :unprocessable_entity
    assert_includes response_json["error"], I18n.t("errors.presence", entity: "To path")
    assert_equal existing_to_path, @redirection.reload.to_path
  end

  def test_shouldnt_create_redirection_with_invalid_params
    assert_no_difference "@site.redirections.size" do
      post(
        api_v1_redirections_path, params: redirection_params({ from_path: "" }),
        headers: auth_headers(@current_user))
      assert_response :unprocessable_entity
    end
    assert_includes response_json["error"], I18n.t("errors.presence", entity: "From path")
  end

  def test_can_destroy_redirection
    assert_difference "@site.redirections.size", -1 do
      delete(api_v1_redirection_path(@redirection.id), headers: auth_headers(@current_user))
      assert_response :success
    end
    assert_equal I18n.t("successfully_deleted", entity: "Redirection"), response_json["notice"]
  end

  def test_shouldnt_destroy_redirection_with_invalid_id
    assert_no_difference "@site.redirections.size" do
      delete(api_v1_redirection_path("invalid-id"), headers: auth_headers(@current_user))
      assert_response :not_found
    end
  end

  private

    def redirection_params(other_attributes = {})
      { redirection: { from_path: "/#{Faker::Lorem.word}", to_path: Faker::Internet.url }.merge!(other_attributes) }
    end
end
