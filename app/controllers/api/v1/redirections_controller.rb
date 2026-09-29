# frozen_string_literal: true

class Api::V1::RedirectionsController < Api::V1::BaseController
  before_action :load_redirection!, only: %i[update destroy]

  def index
    @redirections = @site.redirections
  end

  def create
    @redirection = @site.redirections.create!(redirection_params)
    render_notice(t("successfully_created", entity: "Redirection"))
  end

  def update
    @redirection.update!(redirection_params)
    render_notice(t("successfully_updated", entity: "Redirection"))
  end

  def destroy
    @redirection.destroy!
    render_notice(t("successfully_deleted", entity: "Redirection"))
  end

  private

    def redirection_params
      params.require(:redirection).permit(:from_path, :to_path)
    end

    def load_redirection!
      @redirection = @site.redirections.find(params[:id])
    end
end
