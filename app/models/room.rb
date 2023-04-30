class Room < ApplicationRecord
  belongs_to :quest
  has_many :messages, dependent: :destroy

  validates :quest_id, presence: true
end
