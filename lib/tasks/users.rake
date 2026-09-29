# frozen_string_literal: true

namespace :users do
  desc "Sets a password for an existing user: rake users:set_password[email,password]"
  task :set_password, [:email, :password] => :environment do |_task, args|
    user = User.find_by!(email: args[:email])
    user.update!(password: args[:password])
    puts "Password updated for #{user.email}."
  end
end
