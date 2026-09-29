# frozen_string_literal: true

class Like < ApplicationRecord
  VISITOR_TOKEN_REGEX = /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/

  belongs_to :article, counter_cache: true

  validates :visitor_token, presence: true, format: { with: VISITOR_TOKEN_REGEX, allow_blank: true }
  validates :visitor_token, uniqueness: { scope: :article_id }
end
