# frozen_string_literal: true

require "test_helper"

class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase
  include FactoryBot::Syntax::Methods

  def setup
    @user = create :user
  end

  def test_connection_success_when_token_is_valid
    connect params: { token: @user.authentication_token }
    assert_equal connection.current_user, @user
  end

  def test_connection_fails_when_credentials_are_empty
    assert_reject_connection { connect }
  end

  def test_connection_fails_when_token_is_blank_even_if_a_user_has_no_token
    @user.update_column(:authentication_token, nil)
    assert_reject_connection { connect params: { token: "" } }
  end

  def test_connection_fails_when_only_email_is_given
    assert_reject_connection { connect params: { email: @user.email } }
  end

  def test_connection_fails_with_unknown_token
    assert_reject_connection { connect params: { token: "nope" } }
  end
end
