class Quest < ApplicationRecord
  belongs_to :user
  has_many :challenges
  has_one :room, dependent: :destroy
  has_many :quest_tags, dependent: :destroy
  has_many :tags, through: :quest_tags

  validates :title, presence: true
  validate :describe
  validates :difficulty, presence: true,
                         numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :xp, presence: true, numericality: { only_integer: true }
  validates :public, inclusion: { in: [true, false] }
  validates :user_id, presence: true
  validate :challenge_id


  def self.search(search)
    if !search.nil?
      search_word = search.gsub(/(^[[:space:]]+)|([[:space:]]+$)/, '').split(/[[:space:]]+/)
      Quest.where('title LIKE(?)', "%#{search_word.first}%")
    else
      Quest.eager_load(:user).all
    end
  end
end
