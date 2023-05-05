FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "tag-#{n}"}

    trait :tag_trip do
      name { "trip" }
    end

    trait :tag_sports do
      name { "sports" }
    end

    trait :tag_hobby do
      name { "hobby" }
    end
  end

  factory :other_tag, :class => "Tag" do
    sequence(:name) { |n| "other_tag-#{n}"}
  end
end
