module ApplicationHelper

  def is_not_own_challenge?
    !(Challenge.exists?(user_id: current_user.id, quest_id: @quest.id))
  end

  def current_user_owned?(property)
    property.user == current_user
  end

  def public_quest?(property)
    property.public == true
  end
end
