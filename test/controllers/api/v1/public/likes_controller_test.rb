# frozen_string_literal: true

require "test_helper"

class Api::V1::Public::LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @site = create :site
    @category = create :category, site: @site
    @user = create :user, site: @site
    @article = create :article, category: @category, user: @user
    @token = SecureRandom.uuid
    @headers = public_headers(@site).merge("X-Visitor-Token": @token)
  end

  def test_like_article
    assert_difference -> { @article.reload.likes_count }, 1 do
      post api_v1_public_article_like_path(@article.slug), headers: @headers
    end
    assert_response :success
    assert_equal({ "likes_count" => 1, "liked" => true }, response_json["like"])
  end

  def test_liking_twice_is_idempotent
    2.times { post api_v1_public_article_like_path(@article.slug), headers: @headers }
    assert_response :success
    assert_equal 1, @article.reload.likes_count
    assert_equal 1, @article.likes.count
  end

  def test_unlike_article
    create :like, article: @article, visitor_token: @token
    assert_difference -> { @article.reload.likes_count }, -1 do
      delete api_v1_public_article_like_path(@article.slug), headers: @headers
    end
    assert_response :success
    assert_equal({ "likes_count" => 0, "liked" => false }, response_json["like"])
  end

  def test_unliking_when_not_liked_is_idempotent
    delete api_v1_public_article_like_path(@article.slug), headers: @headers
    assert_response :success
    assert_equal 0, @article.reload.likes_count
  end

  def test_different_visitors_are_counted_separately
    post api_v1_public_article_like_path(@article.slug), headers: @headers
    other = public_headers(@site).merge("X-Visitor-Token": SecureRandom.uuid)
    post api_v1_public_article_like_path(@article.slug), headers: other
    assert_equal 2, @article.reload.likes_count

    delete api_v1_public_article_like_path(@article.slug), headers: other
    assert_equal 1, @article.reload.likes_count
    assert_equal 1, @article.likes.where(visitor_token: @token).count
  end

  def test_missing_visitor_token_is_rejected
    post api_v1_public_article_like_path(@article.slug), headers: public_headers(@site)
    assert_response :unprocessable_entity
    assert_equal 0, @article.reload.likes_count
  end

  def test_malformed_visitor_token_is_rejected
    headers = public_headers(@site).merge("X-Visitor-Token": "abc")
    post api_v1_public_article_like_path(@article.slug), headers: headers
    assert_response :unprocessable_entity
  end

  def test_draft_article_cannot_be_liked
    @article.draft!
    post api_v1_public_article_like_path(@article.slug), headers: @headers
    assert_response :not_found
  end

  def test_unknown_article_returns_not_found
    post api_v1_public_article_like_path("missing"), headers: @headers
    assert_response :not_found
  end

  def test_requires_site_authentication
    post api_v1_public_article_like_path(@article.slug), headers: headers.merge("X-Visitor-Token": @token)
    assert_response :unauthorized
  end
end
