# frozen_string_literal: true

require "test_helper"

class Api::V1::CategoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @site = create :site
    @current_user = create :user, site: @site
    @category = create :category, site: @site
  end

  def test_should_list_all_categories
    create_list :category, 5, site: @site
    get(api_v1_categories_path, headers: auth_headers(@current_user))
    assert_response :success
    assert_equal @site.categories.length, response_json["categories"].length
  end

  def test_should_create_valid_category
    assert_difference "@site.categories.size" do
      post(
        api_v1_categories_path, params: { category: { name: "Userflow" } }, headers: auth_headers(@current_user))
      assert_response :success
    end

    assert_equal I18n.t("successfully_created", entity: "Category"), response_json["notice"]
  end

  def test_shouldnt_create_category_with_invalid_param
    assert_no_difference "@site.categories.size" do
      post(api_v1_categories_path, params: { category: { name: "" } }, headers: auth_headers(@current_user))
      assert_response :unprocessable_entity
    end

    assert_includes response_json["error"], I18n.t("errors.presence", entity: "Name"), response_json["error"]
  end

  def test_should_update_valid_category
    new_name = "Bugs"
    put(
      api_v1_category_path(@category.id), params: { category: { name: new_name } },
      headers: auth_headers(@current_user))
    assert_response :success
    assert_equal I18n.t("successfully_updated", entity: "Category"), response_json["notice"]
    assert_equal new_name, @category.reload.name
  end

  def test_shouldnt_update_category_with_invalid_params
    existing_title = @category.name
    put(api_v1_category_path(@category.id), params: { category: { name: "" } }, headers: auth_headers(@current_user))
    assert_response :unprocessable_entity
    assert_includes response_json["error"], I18n.t("errors.presence", entity: "Name")
    assert_equal existing_title, @category.reload.name
  end

  def test_destroy_category
    delete(api_v1_category_path(@category.id), headers: auth_headers(@current_user))
    assert_response :success
    assert_equal I18n.t("successfully_deleted", entity: "Category"), response_json["notice"]
  end

  def test_creates_default_category_when_last_category_is_deleted_and_has_articles
    user = create :user, site: @site
    create(:article, category: @category, user:)

    assert_no_difference "@site.categories.size" do
      delete(api_v1_category_path(@category.id), headers: auth_headers(@current_user))
      assert_response :success
    end
    assert_equal Category::DEFAULT_CATEGORY_NAME, Category.first.name
    assert_equal I18n.t("successfully_deleted", entity: "Category"), response_json["notice"]
  end

  def test_shouldnt_destroy_category_with_invalid_id
    assert_no_difference "@site.categories.size" do
      delete(api_v1_category_path("invalid-id"), headers: auth_headers(@current_user))
      assert_response :not_found
    end
    assert_equal "Category not found", response_json["error"]
  end

  def test_can_reorder_categories
    second_category = create :category, site: @site
    old_position = @category.position
    target_position = second_category.position
    put(
      api_v1_category_path(@category.id), params: { category: { position: target_position } },
      headers: auth_headers(@current_user))
    assert_equal target_position, @category.reload.position
  end
end
