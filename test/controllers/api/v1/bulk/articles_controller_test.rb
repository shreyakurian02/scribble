# frozen_string_literal: true

require "test_helper"

class Api::V1::Bulk::ArticlesControllerTest < ActionDispatch::IntegrationTest
  def setup
    site = create :site
    category = create(:category, site:)
    @current_user = create(:user, site:)
    @articles = create_list(:article, 5, user: @current_user, category:)
  end

  def test_can_update_bulk_articles
    article_with_published_status = @articles.first
    put(
      api_v1_bulk_articles_path, params: article_params({ article: { status: "draft" } }),
      headers: auth_headers(@current_user))
    assert_response :success
    assert_equal I18n.t("successfully_updated", entity: "Articles"), response_json["notice"]
    assert_equal "draft", article_with_published_status.reload.status
  end

  def test_bulk_articles_update_failure
    invalid_status = "pub"
    put(
      api_v1_bulk_articles_path, params: article_params({ article: { status: invalid_status } }),
      headers: auth_headers(@current_user))
    assert_response :unprocessable_entity
    assert_includes response_json["error"], I18n.t("article.invalid_status", status: invalid_status)
  end

  def test_bulk_destroy_articles
    expected_difference_count = @articles.length
    assert_difference "@current_user.articles.size", -expected_difference_count do
      delete(api_v1_bulk_articles_path, params: article_params, headers: auth_headers(@current_user))
      assert_response :success
    end

    assert_equal I18n.t("successfully_deleted", entity: "Articles"), response_json["notice"]
  end

  private

    def article_params(other_attributes = {})
      { ids: [@articles.pluck(:id)] }.merge!(other_attributes)
    end
end
