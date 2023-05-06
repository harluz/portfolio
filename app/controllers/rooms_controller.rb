class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_room

  def show
    if !current_user_owned?(@room.quest) && !public_quest?(@room.quest)
      flash[:alert] = "非公開クエストのトークルームにアクセスすることはできません。"
      redirect_to quests_path
    else
      @messages = Message.eager_load(:user).where(room_id: params[:id])
    end
  end

  private

  def find_room
    @room = Room.eager_load(quest: [user: :messages]).find(params[:id])
  rescue
    flash[:alert] = "クエストもしくはトークルームが存在していません。"
    redirect_to quests_path
  end
end
