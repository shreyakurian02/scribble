# frozen_string_literal: true

class Api::V1::SitesController < ApplicationController
  before_action :load_site!

  def show
    render
  end

  def update
    @site.update!(site_params)
    render_notice(t("successfully_updated", entity: "Site"))
  end

  private

    def site_params
      params.require(:site).permit(:title)
    end

    def load_site!
      return if (@site = Site.first.presence)

      render_error(t("not_found", entity: "Site"), :not_found)
    end
end