# frozen_string_literal: true

require "test_helper"

class Api::V1::Public::ArticlesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @site = create :site
    @category = create :category, site: @site
    @current_user = create :user, site: @site
    @article = create(:article, :published, category: @category, user: @current_user)
    @headers = public_headers(@site)
  end

  def test_article_is_not_accessible_to_unauthenticated_user
    get(api_v1_public_article_path(@article.slug), headers:)
    assert_response :unauthorized
    assert_includes response_json["error"], I18n.t("session.could_not_auth")
  end

  def test_list_filtered_articles
    articles = create_list(:article, 5, :published, category: @category, user: @current_user)
    search_term = articles.first.title
    articles_with_search_term = @current_user.articles.published.search_by_term_in_title_and_description(search_term)
    get api_v1_public_articles_path, params: {search: search_term}, headers: @headers

    assert_equal articles_with_search_term.ids.sort, response_json["articles"].pluck("id").sort
    assert_equal articles_with_search_term.size, response_json["articles"].size
  end

  def test_should_show_published_article
    get api_v1_public_article_path(@article.slug), headers: @headers
    assert_response :success
    assert_equal %w[category_id description title], response_json["article"].keys.sort
  end

  def test_shouldnt_show_draft_article
    draft_article = create :article, category: @category, user: @current_user
    get api_v1_public_article_path(draft_article.slug), headers: @headers
    assert_response :not_found
    assert_includes response_json["error"], "Article not found"
  end

  def test_article_show_increases_view_count
    view_count_before_show = @article.views
    get api_v1_public_article_path(@article.slug), headers: @headers
    assert_response :success
    assert_equal view_count_before_show + 1, @article.reload.views
  end
end
