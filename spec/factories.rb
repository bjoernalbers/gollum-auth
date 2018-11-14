include Faker

FactoryBot.define do
  factory :user, class: Gollum::Auth::User do
    username { Internet.user_name }
    password { Internet.password }
    name     { Name.name }
    email    { Internet.email }
  end
end
