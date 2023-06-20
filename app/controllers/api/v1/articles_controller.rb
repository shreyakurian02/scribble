# frozen_string_literal: true

class Api::V1::ArticlesController < ApplicationController
  before_action :load_current_user, only: %i[index create show update destroy]
  before_action :load_article!, only: %i[show update destroy]

  def index
    @articles, @filtered_count = Articles::FilterService.new(@current_user, filter_params).process.values_at(
      :articles,
      :filtered_count)
  end

  def create
    @current_user.articles.create!(article_params)
    render_notice(t("successfully_created", entity: "Article"))
  end

  def show
    render
  end

  def update
    @article.update!(article_params)
    render_notice(t("successfully_updated", entity: "Article"))
  end

  def destroy
    @article.destroy!
    render_notice(t("successfully_deleted", entity: "Article"))
  end

  private

    def article_params
      params.require(:article).permit(:title, :description, :status, :category_id)
    end

    def load_article!
      @article = @current_user.articles.find_by!(slug: params[:slug])
    end

    def filter_params
      params.permit(:status, :search, :per_page, :page_number, categories: [])
    end
end
