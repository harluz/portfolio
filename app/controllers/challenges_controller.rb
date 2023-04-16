class ChallengesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_challenge, only: [:update, :destroy]
  before_action :ensure_user, only: [:update, :destroy]

  def index
    @challenges = Challenge.where(user_id: current_user.id, close: false)
  end

  def closed
    @challenges = Challenge.where(user_id: current_user.id, close: true)
  end

  def create
    @challenge = Challenge.new(challenge_params)
    begin
      @quest = Quest.find(params[:challenge][:quest_id])
    rescue
      flash[:alert] = "クエストデータが見つかりません。"
      redirect_to challenges_path
      return
    end

    if is_not_own_challenge?(@quest) && (current_user_owned?(@quest) || (!current_user_owned?(@quest) && public_quest?(@quest)))
      @challenge.user_id = current_user.id
      @challenge.quest_id = @quest.id
      @challenge.save
      flash[:notice] = "挑戦リストに追加されました。"
      redirect_to challenges_path
    else
      flash[:alert] = "挑戦リストの追加に失敗しました。"
      redirect_to challenges_path
    end
  end

  def update
    if @challenge.update(challenge_params)
      case params[:challenge][:close]
      when "true"
        @user = User.find(@challenge.user_id)
        @user.having_xp += @challenge.quest.xp
        @user.save(validate: false)
        flash[:notice] = "クエスト達成おめでとうございます。経験値#{@challenge.quest.xp}ポイントを獲得しました。"
        redirect_to challenges_path
      when "false"
        flash[:notice] = "挑戦リストに追加されました。"
        redirect_to challenges_path
      end
    else
      flash[:alert] = "クエスト達成の更新ができませんでした。"
      redirect_to challenges_path
    end
  end

  def destroy
    @challenge.destroy
    flash[:notice] = "挑戦リストから削除しました。"
    redirect_to challenges_path
  end

  private

  def challenge_params
    params.require(:challenge).permit(:quest_id, :close)
  end

  def find_challenge
    @challenge = Challenge.find(params[:id])
  rescue
    flash[:alert] = "挑戦中のデータが見つかりません。"
    redirect_to challenges_path
  end

  def ensure_user
    unless current_user_owned?(@challenge)
      flash[:alert] = "他のユーザーの挑戦を操作することはできません。"
      redirect_to challenges_path
    end
  end
end
