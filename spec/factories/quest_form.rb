FactoryBot.define do
  factory :quest_form do
    title { "Create a quest you want to complete." }
    describe { "Create quest achievement conditions." }
    difficulty { 3 }
    xp { 6 }
    public { false }
    name { ["sample", "example"] }
  end

  factory :non_correct_quest_form, :class => "QuestForm" do
    title { "" }
    describe { "Non correct sample describe" }
    difficulty { 5 }
    xp { 10 }
    public { true }
    name { ["sample", "example"] }
  end

  factory :other_quest_form, :class => "QuestForm" do
    title { "Quests that other people want to complete" }
    describe { "Conditions for completing quests set by others" }
    difficulty { 5 }
    xp { 10 }
    public { false }
    name { ["other", "keyword"] }
  end
end
