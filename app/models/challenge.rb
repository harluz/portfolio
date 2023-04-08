class Challenge < ApplicationRecord
  belongs_to :user
  belongs_to :quest

  validate :user_id
  validate :quest_id
  validate :close
end
