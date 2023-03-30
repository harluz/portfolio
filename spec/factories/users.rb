FactoryBot.define do
  factory :user do
    name { "sample user" }
    email { "sample@mail.com" }
    password { "samplepassword" }
  end

  factory :non_correct_user, class: User do
    name { "" }
    email { "samplemailcom" }
    password { "pass" }
  end

  factory :duplicate_user, class: User do
    name { "sample user2" }
    email { "sample@mail.com" }
    password { "samplepassword2" }
  end
end
