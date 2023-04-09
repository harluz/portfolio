# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

2.times do |n|
  User.create!(
    name: "sample#{n+1}",
    email: "sample#{n+1}@mail.com",
    password: "password",
    password_confirmation: "password"
  )
end

10.times do |n|
  Quest.create!(
    title: "My sample title#{n + 1} public false",
    describe: "My sample describe#{n + 1}",
    difficulty: 3,
    public: false,
    xp: 6, 
    user_id: 1
  )
end

10.times do |n|
  Quest.create!(
    title: "My sample title#{n + 10} public true",
    describe: "Mysample describe#{n + 10}",
    difficulty: 4,
    public: true,
    xp: 8,
    user_id: 1
  )
end

10.times do |n|
  Quest.create!(
    title: "Other sample title#{n + 1} public false",
    describe: "Other sample describe#{n + 1}",
    difficulty: 2,
    public: false,
    xp: 4,
    user_id: 2
  )
end

10.times do |n|
  Quest.create!(
    title: "sample title#{n + 1} public true",
    describe: "sample describe#{n + 1}",
    difficulty: 1,
    public: true,
    xp: 2,
    user_id: 2
  )
end

5.times do |n|
  Challenge.create!(
    user_id: 1,
    quest_id: n + 1,
    close: false
  )
end

5.times do |n|
  Challenge.create!(
    user_id: 1,
    quest_id: n + 20,
    close: false
  )
end

5.times do |n|
  Challenge.create!(
    user_id: 1,
    quest_id: n + 10,
    close: true
  )
end

5.times do |n|
  Challenge.create!(
    user_id: 1,
    quest_id: n + 30,
    close: true
  )
end

5.times do |n|
  Challenge.create!(
    user_id: 2,
    quest_id: n + 5,
    close: false
  )
end

5.times do |n|
  Challenge.create!(
    user_id: 2,
    quest_id: n + 25,
    close: false
  )
end

5.times do |n|
  Challenge.create!(
    user_id: 2,
    quest_id: n + 15,
    close: true
  )
end

5.times do |n|
  Challenge.create!(
    user_id: 2,
    quest_id: n + 35,
    close: true
  )
end
