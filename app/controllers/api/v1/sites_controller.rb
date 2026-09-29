# frozen_string_literal: true

class Api::V1::SitesController < Api::V1::BaseController
  def show
    render
  end

  def update
    @site.update!(site_params)
    render_notice(t("successfully_updated", entity: "Site"))
  end

  private

    def site_params
      params.require(:site).permit(:title, :password)
    end
end
