# frozen_string_literal: true

module SampleData
  class UserService < BaseService
    def process!
      create_user!
    end

    private

      def create_user!
        site.users.create!(
          email: "oliver@example.com", first_name: "Oliver", last_name: "Smith",
          password: "welcome", password_confirmation: "welcome"
        )
      end
  end
end
