class QuestForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  # attr_accessor :id, :title, :describe, :difficulty, :xp, :public, :name, :user_id

  attribute :id, :integer
  attribute :title
  attribute :describe, :string
  attribute :difficulty, :integer, default: 1
  attribute :xp, :integer
  attribute :public, default: false
  attribute :name, :string
  attribute :user_id, :integer
  attribute :challenge_id, :integer
  # attribute :created_at, :date
  # attribute :updated_at, :date

  # validate :id
  # validate :describe
  # validates :name, presence: true, unless: -> { quest.tags.present? }
  validates :title, presence: true
  validates :difficulty, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :xp, presence: true, numericality: { only_integer: true }
  validates :public, inclusion: { in: [true, false] }
  # validates :name, presence: true
  validates :user_id, presence: true

  # def self.find(id)
  #   quest = Quest.find(id)
  #   tag_names = quest.tags.pluck(:name).join(' ')
  #   tag_hash = { "name" => tag_names }
  #   form_attributes = quest.attributes.except("challenge_id", "created_at", "updated_at").merge(tag_hash)
  #   QuestForm.new(form_attributes)
  # end

  def save
    return false unless valid?
    quest = Quest.create(title: title, describe: describe, difficulty: difficulty, xp: xp, public: public, user_id: user_id)
    Challenge.create(user_id: user_id, quest_id: quest.id)
    Room.create(quest_id: quest.id)
    self.id = quest.id
    create_tags(quest) if name.present?
    true
  end

  def update(quest_params, quest)
    return false unless valid?
    # quest.assign_attributes(title: title, describe: describe, difficulty: difficulty, xp: xp, public: public, user_id: user_id)
    update_params = quest_params
    update_params[:public] = ( update_params[:public] == "1" )
    update_params[:xp] = ( update_params[:difficulty].to_i * 2 )
    quest.assign_attributes(update_params.slice(:title, :describe, :difficulty, :xp, :public, :user_id))
    # quest.public = ( quest.public == "1" )
    # quest.xp = quest.difficulty.to_i * 2

    if quest.save
      update_tags(update_params, quest)
      true
    else
      false
    end
  end

  private

  def create_tags(quest)
    # if quest.name && quest.name.present?
    # if name.present?
    # if quest.tags.present? && name.blank?
    #   quest.tags.clear
    # else
    # tag_list = name.gsub(/(^[[:space:]]+)|([[:space:]]+$)/, '').split(/[[:space:]]+/).uniq
    new_tags = name.gsub(/(^[[:space:]]+)|([[:space:]]+$)/, '').split(/[[:space:]]+/).uniq
    # current_tags = quest.tags.pluck(:name) unless quest.tags.nil?
    # old_tags = current_tags - tag_list
    # new_tags = tag_list - current_tags

    # old_tags.each do |old|
    #   quest.tags.delete Tag.find_by(name: old)
    # end

    new_tags.each do |new|
      new_quest_tag = Tag.find_or_create_by(name: new)
      quest.tags << new_quest_tag
    end
    # end
  end

  def update_tags(update_params, quest)
    if quest.tags.present? && update_params[:name].blank?
      quest.tags.clear
    else
      tag_list = update_params[:name].gsub(/(^[[:space:]]+)|([[:space:]]+$)/, '').split(/[[:space:]]+/).uniq
      current_tags = quest.tags.pluck(:name) unless quest.tags.nil?
      old_tags = current_tags - tag_list
      new_tags = tag_list - current_tags

      old_tags.each do |old|
        quest.tags.delete Tag.find_by(name: old)
      end
  
      new_tags.each do |new|
        new_quest_tag = Tag.find_or_create_by(name: new)
        quest.tags << new_quest_tag
      end
    end
    # elsif quest.tags.present? && name.blank?
    #   quest.tags.clear
    # end
  end
end