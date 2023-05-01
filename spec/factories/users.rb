FactoryBot.define do
  factory :user do
    name { "sample user" }
    email { "sample@mail.com" }
    password { "samplepassword" }
    having_xp { 100 }
  end

  factory :correct_user, :class => "User" do
    name { "correct user" }
    email { "correct@mail.com" }
    password { "correctpassword" }
  end

  factory :non_correct_user, :class => "User" do
    name { "" }
    email { "samplemailcom" }
    password { "pass" }
  end

  factory :duplicate_user, :class => "User" do
    name { "sample user2" }
    email { "duplicate@mail.com" }
    password { "samplepassword2" }
  end
end
