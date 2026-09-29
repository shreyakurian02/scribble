# frozen_string_literal: true

require "test_helper"

class Api::V1::Articles::VersionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @site = create :site
    @current_user = create :user, site: @site
    category = create :category, site: @site
    @article = create(:article, user: @current_user, category:)
  end

  def test_can_show_article_version_for_valid_params
    @article.update!(title: Faker::Name.first_name)
    get(api_v1_article_version_path(@article.id, @article.versions.first.id), headers: auth_headers(@current_user))
    assert_response :success
    assert_equal %w[article_category description title version_category], response_json["version"].keys.sort
  end

  def test_can_restore_article_to_old_version
    title_before_updating = @article.title
    @article.update!(title: Faker::Name.first_name)
    put(
      restore_api_v1_article_version_path(@article.id, @article.versions.first.id),
      headers: auth_headers(@current_user))
    assert_response :success
    assert_equal I18n.t("successfully_restored", entity: "Article"), response_json["notice"]
    assert_equal title_before_updating, @article.reload.title
  end

  def test_restore_to_latest_versions_category_when_old_version_category_is_deleted
    category_before_updating = @article.category
    new_category = create :category, site: @site
    @article.update!(category: new_category)
    category_before_updating.destroy!
    put(
      restore_api_v1_article_version_path(@article.id, @article.versions.first.id),
      headers: auth_headers(@current_user))

    assert_response :success
    assert_equal I18n.t("successfully_restored", entity: "Article"), response_json["notice"]
    assert_equal new_category, @article.category
  end

  def test_cannot_show_article_version_for_invalid_params
    @article.update!(title: Faker::Name.first_name)
    get(api_v1_article_version_path("invalid-article-slug", "invalid-version-id"), headers: auth_headers(@current_user))
    assert_response :not_found
  end
end
