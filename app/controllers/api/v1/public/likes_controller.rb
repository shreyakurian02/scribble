# frozen_string_literal: true

class Api::V1::Public::LikesController < Api::V1::Public::BaseController
  before_action :load_article!
  before_action :validate_visitor_token!

  def create
    like_article
    render :show
  end

  def destroy
    @article.likes.find_by(visitor_token:)&.destroy!
    render :show
  end

  private

    def load_article!
      @article = @site.articles.published.find_by!(slug: params[:article_slug])
    end

    def validate_visitor_token!
      return if visitor_token.to_s.match?(Like::VISITOR_TOKEN_REGEX)

      render_error(t("errors.invalid_visitor_token"), :unprocessable_entity)
    end

    def like_article
      @article.likes.find_or_create_by!(visitor_token:)
    rescue ActiveRecord::RecordNotUnique
      # A concurrent request already recorded this like; nothing more to do.
    end
end
