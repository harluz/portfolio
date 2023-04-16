FactoryBot.define do
  factory :quest do
    title { "Create a quest you want to complete." }
    describe { "Create quest achievement conditions." }
    difficulty { 3 }
    xp { 6 }
    public { false }
  end

  factory :public_quest, :class => "Quest" do
    title { "Public quest" }
    describe { "Public quest description" }
    difficulty { 2 }
    xp { 4 }
    public { true }
  end

  factory :non_public_quest, :class => "Quest" do
    title { "Non public quest" }
    describe { "Non public quest description" }
    difficulty { 1 }
    xp { 2 }
    public { false }
  end

  factory :other_quest, :class => "Quest" do
    title { "Quests that other people want to complete" }
    describe { "Conditions for completing quests set by others" }
    difficulty { 5 }
    xp { 10 }
    public { false }
  end

  factory :public_other_quest, :class => "Quest" do
    title { "Public other quest" }
    describe { "Public other quest description" }
    difficulty { 4 }
    xp { 8 }
    public { true }
  end

  factory :non_correct_quest, :class => "Quest" do
    title { "" }
    describe { "Non correct sample describe" }
    difficulty { 5 }
    xp { 10 }
    public { true }
  end
end
