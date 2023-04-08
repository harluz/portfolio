class Quest < ApplicationRecord
  belongs_to :user
  has_many :challenges

  validates :title, presence: true
  validate :describe
  validates :difficulty, presence: true, numericality: { only_integer: true, in: 1..5 }
  validates :xp, presence: true, numericality: { only_integer: true }
  validates :public, inclusion: { in: [true, false] }
  validate :challenge_id
  validate :user_id

  def set_xp
    difficulty * 2
  end
end
