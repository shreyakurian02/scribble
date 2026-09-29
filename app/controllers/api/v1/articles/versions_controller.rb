# frozen_string_literal: true

class Api::V1::Articles::VersionsController < Api::V1::BaseController
  before_action :load_article!, only: %i[show restore]
  before_action :load_version!, only: %i[show restore]

  def show
    render
  end

  def restore
    @article.paper_trail_event = "restored"
    @article.update!(article_params)
    render_notice(t("successfully_restored", entity: "Article"))
  end

  private

    def load_version!
      @version = @article.versions.find(params[:id]).next.reify
    end

    def article_params
      category = @version.category || @article.category
      @version.as_json.extract!("title", "description").merge!(status: :draft, category_id: category.id)
    end

    def load_article!
      @article = current_user.articles.find(params[:article_id])
    end
end
