# frozen_string_literal: true

require "test_helper"

class LikeTest < ActiveSupport::TestCase
  def setup
    @like = create :like
  end

  def test_visitor_token_is_required
    like = build :like, visitor_token: nil
    assert_not like.valid?
    assert_includes like.errors[:visitor_token], "can't be blank"
  end

  def test_visitor_token_must_be_a_uuid
    like = build :like, visitor_token: "not-a-uuid"
    assert_not like.valid?
    assert_includes like.errors[:visitor_token], "is invalid"
  end

  def test_same_visitor_cannot_like_an_article_twice
    duplicate = build :like, article: @like.article, visitor_token: @like.visitor_token
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:visitor_token], "has already been taken"
  end

  def test_same_visitor_can_like_different_articles
    other_article = create :article, category: @like.article.category, user: @like.article.user
    assert build(:like, article: other_article, visitor_token: @like.visitor_token).valid?
  end

  def test_likes_count_is_kept_in_sync
    article = @like.article
    assert_equal 1, article.reload.likes_count
    create(:like, article:)
    assert_equal 2, article.reload.likes_count
    @like.destroy
    assert_equal 1, article.reload.likes_count
  end
end
