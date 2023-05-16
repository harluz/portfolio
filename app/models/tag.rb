class Tag < ApplicationRecord
  has_many :quest_tags, dependent: :destroy
  has_many :quests, through: :quest_tags

  # validates :name, presence: true, uniqueness: true
  validates :name, uniqueness: true

  def self.search(search)
    search_word = search.sub(/#/, '').split(/[[:space:]]+/)
    if search_word && search_word.present?
      tag = Tag.where(name: search_word.first)
      if tag && tag.present?
        tag.first.quests
      else
        Quest.eager_load(:user).all
      end
    else
      Quest.eager_load(:user).all
    end
  end
end
