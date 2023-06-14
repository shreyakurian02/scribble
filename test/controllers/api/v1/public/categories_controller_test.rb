# frozen_string_literal: true

require "test_helper"

class Api::V1::Public::CategoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    create_list(:category, 5)
  end

  def test_should_list_all_categories
    get(api_v1_public_categories_path, headers:)
    assert_response :success
    assert_equal 5, response_json["categories"].length
  end
end
