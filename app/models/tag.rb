class Tag < ApplicationRecord
  has_many :quest_tags, dependent: :destroy
  has_many :quests, through: :quest_tags

  validates :name, presence: true, uniqueness: true

  def self.search(search)
    search_word = search.sub(/#/, '').split(/[[:space:]]+/)
    if search_word && !search_word.blank?
      tag = Tag.where(name: search_word)
      if tag && !tag.blank?
        tag[0].quests
      else
        Quest.all
      end
    else
      Quest.all
    end
  end
end
