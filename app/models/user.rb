# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  has_many :articles, class_name: "Article", foreign_key: :author_id, dependent: :destroy

  validates :first_name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  before_save :downcase_email

  private

    def downcase_email
      email.downcase!
    end
end