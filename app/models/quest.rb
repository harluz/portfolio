class Quest < ApplicationRecord
  validates :title, presence: true
  validate :describe
  validates :difficulty, presence: true, numericality: { only_integer: true, in: 1..5 }
  validates :xp, presence: true, numericality: { only_integer: true }
  validates :public, inclusion: { in: [true, false] }
  validate :challenge_id
end
