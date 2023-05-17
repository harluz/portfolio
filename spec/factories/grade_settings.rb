FactoryBot.define do
  factory :first_stepper, :class => "GradeSetting" do
    tag { 1 }
    grade { "First Stepper" }
    judgement_xp { 30 }
  end

  factory :second_stepper, :class => "GradeSetting" do
    tag { 2 }
    grade { "Second Stepper" }
    judgement_xp { 70 }
  end

  factory :noticer, :class => "GradeSetting" do
    tag { 3 }
    grade { "Noticer" }
    judgement_xp { 120 }
  end

  factory :discoverer, :class => "GradeSetting" do
    tag { 4 }
    grade { "Discoverer" }
    judgement_xp { 180 }
  end

  factory :changer, :class => "GradeSetting" do
    tag { 5 }
    grade { "Changer" }
    judgement_xp { 250 }
  end

  factory :challenger, :class => "GradeSetting" do
    tag { 6 }
    grade { "Challenger" }
    judgement_xp { 330 }
  end

  factory :accomplisher, :class => "GradeSetting" do
    tag { 7 }
    grade { "Accomplisher" }
    judgement_xp { 420 }
  end

  factory :legend, :class => "GradeSetting" do
    tag { 8 }
    grade { "Legend" }
    judgement_xp { 520 }
  end
end
