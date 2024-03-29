# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { Faker::Lorem.sentence(word_count: 2) }
    site
  end
end
