class Room < ApplicationRecord
  belongs_to :quest
  has_many :messages, dependent: :destroy
end
