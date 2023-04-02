FactoryBot.define do
  factory :quest do
    title { "MyString" }
    describe { "MyText" }
    difficulty { 1 }
    xp { 1 }
    public { false }
  end
end
