class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.where(user_id: current_user.id, close: false)
  end

  def closed
    @challenges = Challenge.where(user_id: current_user.id, close: true)
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
    @challenge = Challenge.find(params[:id])
    case params[:challenge][:close]
    when "true"
      if @challenge.update(challenge_params)
        @user = User.find(@challenge.user_id)
        @user.having_xp += @challenge.quest.xp
        @user.save(validate: false)
        flash[:notice] = "クエスト達成おめでとうございます。経験値#{@challenge.quest.xp}ポイントを獲得しました。"
        redirect_to challenges_path
      else
        flash[:alert] = "クエスト達成の更新ができませんでした。達成ボタンをクリックください。"
        redirect_to challenge_path(@challenge.quest)
      end
    when "false"
      if @challenge.update(challenge_params)
        flash[:notice] = "挑戦リストに追加しました。"
        redirect_to challenges_path
      else
        flash[:alert] = "クエスト達成の更新ができませんでした。達成ボタンをクリックください。"
        redirect_to challenge_path(@challenge.quest)
      end
    end
  end

  def destroy
    @challenge = Challenge.find(params[:id])
    @challenge.destroy
    redirect_to challenges_path
  end

  private

  def challenge_params
    params.require(:challenge).permit(:quest_id, :close)
  end
end
