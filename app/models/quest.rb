class Quest < ApplicationRecord
  belongs_to :user
  has_many :challenges

  validates :title, presence: true
  validate :describe
  validates :difficulty, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :xp, presence: true, numericality: { only_integer: true }
  validates :public, inclusion: { in: [true, false] }
  validates :user_id, presence: true
  validate :challenge_id

  def set_xp
    difficulty * 2
  end
end
