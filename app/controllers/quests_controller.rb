class QuestsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :ensure_user, only: [:edit, :update, :destroy]

  def index
    @quests = Quest.all
  end

  def new
    @quest = Quest.new(session[:quest] || {})
  end

  def create
    @quest = Quest.new(quest_params)
    @quest.user_id = current_user.id
    @quest.xp = @quest.set_xp

    if @quest.save
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
    @quest = Quest.find(params[:id])
  end

  def edit
    @quest = Quest.find(params[:id])
  end

  def update
    @quest = Quest.find_by(params[:id])
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
  end

  private

  def quest_params
    params.require(:quest).permit(:title, :describe, :difficulty, :xp, :public)
  end

  def ensure_user
    @quests = current_user.quests
    @quest = @quests.find_by(id: params[:id])
    unless @quest
      flash[:alert] = "他のユーザーのクエストを操作することはできません。"
      redirect_to quests_path
    end
  end
end
