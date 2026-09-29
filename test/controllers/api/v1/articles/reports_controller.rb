# frozen_string_literal: true

require "test_helper"

class Api::V1::Articles::ReportsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create :user
  end

  def test_can_generate_report
    post(api_v1_report_path, headers: auth_headers(@user))
    assert_response :success
    assert @user.reload.report.attached?
  end

  def test_can_download_report
    report = ActiveStorage::Blob.create_and_upload!(
      io: File.open("test/fixtures/report.pdf"),
      filename: "articles-report.pdf",
      content_type: "application/pdf"
    )
    @user.report.attach(report)
    get(download_api_v1_report_path, headers: auth_headers(@user))
    assert_response :success
  end

  def test_download_report_failure
    get(download_api_v1_report_path, headers: auth_headers(@user))
    assert_response :not_found
    assert_includes response_json["error"], "Report not found"
  end
end
