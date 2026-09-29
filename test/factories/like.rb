# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    article
    visitor_token { SecureRandom.uuid }
  end
end
