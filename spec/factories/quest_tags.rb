FactoryBot.define do
  factory :quest_tag do
    association :quest
    association :tag
  end
end
