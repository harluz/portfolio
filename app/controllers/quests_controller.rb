class QuestsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_quest, only: [:show, :edit, :update, :destroy]
  before_action :ensure_user, only: [:edit, :update, :destroy]

  def index
    @quests = Quest.all
  end

  def my_quest
    @quests = current_user.quests
  end

  def new
    @quest = Quest.new(session[:quest] || {})
  end

  def create
    @quest = Quest.new(quest_params)
    @quest.user_id = current_user.id
    @quest.xp = @quest.set_xp

    if @quest.save
      @challenge = Challenge.create(user_id: current_user.id, quest_id: @quest.id)
      session[:quest] = nil
      flash[:notice] = "BranChannelに新たなクエストが作成されました。"
      redirect_to quest_path(@quest)
    else
      session[:quest] = @quest.attributes.slice(*quest_params.keys)
      flash[:alert] = "クエストの作成に失敗しました。"
      redirect_to new_quest_path, flash: { error_title: @quest.errors.full_messages_for(:title) }
    end
  end

  def show
    if !current_user_owned?(@quest) && !public_quest?(@quest)
      flash[:alert] = "公開されていないクエストの詳細を見ることはできません。"
      redirect_to quests_path
    elsif !current_user_owned?(@quest) || (current_user_owned?(@quest) && is_not_own_challenge?(@quest))
      @challenge = Challenge.new
    end

    # 他人のクエストを挑戦中にクエストが非公開になった場合、詳細は見れないがchallenge一覧から「達成」or「諦める」を選択できるようにする
    # challengeを特定して、challenge.idを取得した上で↓
    # if @quest.user != current_user && Challenge.exist?(user_id: current_user.id, quest_id: @quest.id)
    # && @quest.public == flase && @challenge.close == false

    # 自分のクエストでなければ、空のchallengeを生成する
  end

  def edit
  end

  def update
    params[:quest][:xp] = params[:quest][:difficulty].to_i * 2

    if @quest.update(quest_params)
      flash[:notice] = "クエストを更新しました。"
      redirect_to quest_path(@quest)
    else
      flash[:alert] = "クエストの更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    if !public_quest?(@quest) && @quest.destroy
      flash[:notice] = "クエストが削除されました。"
      redirect_to quests_path
    else
      flash[:alert] = "公開中のクエストは削除することができません。"
      redirect_to edit_quest_path(@quest)
    end
  end

  private

  def quest_params
    params.require(:quest).permit(:title, :describe, :difficulty, :xp, :public)
  end

  def find_quest
    @quest = Quest.find(params[:id])
  rescue
    flash[:alert] = "クエストが存在していません。"
    redirect_to quests_path
  end

  def ensure_user
    unless current_user_owned?(@quest)
      flash[:alert] = "他のユーザーのクエストを操作することはできません。"
      redirect_to quests_path
    end
  end
end
