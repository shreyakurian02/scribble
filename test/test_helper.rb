# frozen_string_literal: true

def enable_test_coverage
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
    add_group "Models", "app/models"
    add_group "Mailers", "app/mailers"
    add_group "Controllers", "app/controllers"
    add_group "Uploaders", "app/uploaders"
    add_group "Helpers", "app/helpers"
    add_group "Workers", "app/workers"
    add_group "Services", "app/services"
  end
end

enable_test_coverage if ENV["COVERAGE"]

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  parallelize(workers: :number_of_processors) unless ENV["COVERAGE"]

  def response_json
    response.parsed_body
  end

  def headers
    {
      Accept: "application/json",
      "Content_Type": "application/json"
    }
  end

  def public_headers(site)
    headers.merge({ "X-Auth-Token": site.authentication_token })
  end

  def auth_headers(user)
    headers.merge({ "X-User-Token": user.authentication_token })
  end

  def convert_to_ist(datetime)
    datetime.in_time_zone("Kolkata").strftime("%d-%m-%Y %H:%M:%S")
  end
end
