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

  def set_xp
    difficulty * 2
  end

  def save_tag(sent_tags)
    current_tags = tags.pluck(:name) unless tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      tags.delete Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_quest_tag = Tag.find_or_create_by(name: new)
      tags << new_quest_tag
    end
  end

  def self.search(search)
    if !search.nil?
      search_word = search.gsub(/(^[[:space:]]+)|([[:space:]]+$)/, '').split(/[[:space:]]+/)
      Quest.where('title LIKE(?)', "%#{search_word.first}%")
    else
      Quest.all
    end
  end
end
