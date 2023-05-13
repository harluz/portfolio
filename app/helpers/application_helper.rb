module ApplicationHelper
  BASE_TITLE = "BranChannel".freeze

  def full_title(page_title)
    if page_title.blank?
      BASE_TITLE
    else
      "#{page_title} | BranChannel"
    end
  end

  def is_not_own_challenge?(quest)
    !Challenge.exists?(user_id: current_user.id, quest_id: quest.id)
  end

  def current_user_owned?(property)
    property.user == current_user
  end

  def public_quest?(property)
    property.public == true
  end
end
