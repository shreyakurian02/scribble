# frozen_string_literal: true

class Api::V1::CategoriesController < Api::V1::BaseController
  before_action :load_category!, only: %i[update destroy]

  def index
    @categories = Categories::FilterService.new(@site, filter_params).process
  end

  def create
    @site.categories.create!(category_params)
    render_notice(t("successfully_created", entity: "Category"))
  end

  def update
    @category.update!(category_params)
    render_notice(t("successfully_updated", entity: "Category")) unless params.key?(:quiet)
  end

  def destroy
    Categories::DeletionService.new(@site, @category, params[:move_to_category_id]).process!
    render_notice(t("successfully_deleted", entity: "Category"))
  end

  private

    def category_params
      params.require(:category).permit(:name, :position)
    end

    def filter_params
      params.permit(:search)
    end

    def load_category!
      @category = @site.categories.find(params[:id])
    end
end
