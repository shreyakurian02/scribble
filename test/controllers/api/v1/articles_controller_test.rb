# frozen_string_literal: true

require "test_helper"

class Api::V1::ArticlesControllerTest < ActionDispatch::IntegrationTest
  def setup
    site = create :site
    @current_user = create(:user, site:)
    @category = create(:category, site:)
    @article = create :article, category: @category, user: @current_user
  end

  def test_should_list_all_articles
    create_list :article, 5, category: @category, user: @current_user
    get(api_v1_articles_path, headers: auth_headers(@current_user))
    assert_response :success
    assert_equal @current_user.articles.length, response_json["articles"].length
  end

  def test_should_create_valid_article
    assert_difference "@current_user.articles.size" do
      post(
        api_v1_articles_path, params: article_params({ category_id: @category.id }),
        headers: auth_headers(@current_user))
      assert_response :success
    end

    assert_equal I18n.t("successfully_created", entity: "Article"), response_json["notice"]
  end

  def test_should_update_valid_article
    new_title = "Updated title"
    put(
      api_v1_article_path(@article.id), params: article_params({ title: new_title }),
      headers: auth_headers(@current_user))
    assert_response :success
    assert_equal I18n.t("successfully_updated", entity: "Article"), response_json["notice"]
    assert_equal new_title, @article.reload.title
  end

  def test_shouldnt_update_article_with_invalid_params
    existing_title = @article.title
    put(api_v1_article_path(@article.id), params: article_params({ title: "" }), headers: auth_headers(@current_user))
    assert_response :unprocessable_entity
    assert_includes response_json["error"], I18n.t("errors.presence", entity: "Title")
    assert_equal existing_title, @article.reload.title
  end

  def test_destroy_article
    assert_difference "@current_user.articles.size", -1 do
      delete(api_v1_article_path(@article.id), headers: auth_headers(@current_user))
      assert_response :success
    end
    assert_equal I18n.t("successfully_deleted", entity: "Article"), response_json["notice"]
  end

  def test_shouldnt_destroy_article_with_invalid_slug
    assert_no_difference "@current_user.articles.size" do
      delete(api_v1_article_path("invalid-slug"), headers: auth_headers(@current_user))
      assert_response :not_found
    end
    assert_includes response_json["error"], "Article not found"
  end

  def test_should_show_article
    get(api_v1_article_path(@article.id), headers: auth_headers(@current_user))
    assert_response :success
    assert_equal %w[author category description id last_published_at likes_count slug status title updated_at versions
      views], response_json["article"].keys.sort
  end

  def test_shouldnt_create_article_with_invalid_params
    assert_no_difference "@current_user.articles.size" do
      post(api_v1_articles_path, params: article_params, headers: auth_headers(@current_user))
      assert_response :unprocessable_entity
    end
    assert_includes response_json["error"], I18n.t("errors.must_exist", entity: "Category")
  end

  private

    def article_params(other_attributes = {})
      { article: { title: Faker::Lorem.word, description: Faker::Lorem.word }.merge!(other_attributes) }
    end
end
