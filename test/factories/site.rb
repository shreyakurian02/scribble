# frozen_string_literal: true

FactoryBot.define do
  factory :site do
    title { Faker::Lorem.sentence(word_count: 2) }
    password { "welcome2" }
  end
end
