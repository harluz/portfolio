FactoryBot.define do
  factory :challenge do
    user_id { 1 }
    quest_id { 1 }
    close { false }
  end

  factory :closed_challenge, :class => "Challenge" do
    user_id { 1 }
    quest_id { 1 }
    close { true }
  end
end
