FactoryBot.define do
  factory :quest do
    title { "Create a quest you want to complete." }
    describe { "Create quest achievement conditions." }
    difficulty { 3 }
    xp { 6 }
    public { false }
  end

  factory :other_quest, :class => "Quest" do
    title { "Quests that other people want to complete" }
    describe { "Conditions for completing quests set by others" }
    difficulty { 5 }
    xp { 10 }
    public { false }
  end

  factory :non_correct_quest, :class => "Quest" do
    title { "" }
    describe { "Create quest achievement conditions." }
    difficulty { 5 }
    xp { 10 }
    public { false }
  end
end
