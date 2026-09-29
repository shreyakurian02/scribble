# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  belongs_to :site

  has_many :articles, dependent: :destroy
  has_one_attached :report
  has_secure_password
  has_secure_token :authentication_token

  validates :first_name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { scope: :site_id }
  validates :password, length: { minimum: 6 }, allow_nil: true

  def name
    [first_name, last_name].join(" ").strip
  end
end
