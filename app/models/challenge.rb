class Challenge < ApplicationRecord
  belongs_to :user
  belongs_to :quest

  validates :user_id, presence: true
  validates :quest_id, presence: true
  validates :close, inclusion: { in: [true, false] }
end
