include Faker

FactoryGirl.define do
  factory :user, class: Gollum::Auth::User do
    name     { Name.name }
    password { Internet.password }
    email    { Internet.email }
  end
end
