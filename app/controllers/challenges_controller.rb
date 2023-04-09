class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.where(user_id: current_user.id)
  end

  def new
  end
  
  def create
    @challenge = Challenge.new(challenge_params)
    @quest = Quest.find(params[:challenge][:quest_id])
    @challenge.user_id = current_user.id
    @challenge.quest_id = @quest.id
    if @challenge.save
      flash[:notice] = "挑戦リストに追加されました。"
      redirect_to challenges_path
    else
      flash[:alert] = "挑戦リストの追加に失敗しました。"
      redirect_to challenges_path
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end

  private

  def challenge_params
    params.require(:challenge).permit(:quest_id)
  end
end
