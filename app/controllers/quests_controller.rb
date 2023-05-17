class QuestsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  skip_before_action :quest_session_destroy, only: [:new, :create, :edit, :update]
  before_action :find_quest, only: [:show, :destroy]
  before_action :find_quest_form, only: [:edit, :update]
  before_action :ensure_user, only: [:edit, :update, :destroy]

  def index
    if params[:search] && params[:search][0] == '#'
      @quests = Tag.eager_load(quest_tags: [quest: :user]).search(params[:search]).order(created_at: :desc)
    else
      @quests = Quest.eager_load(:user).search(params[:search]).order(created_at: :desc)
    end
  end

  def my_quest
    @quests = current_user.quests.order(created_at: :desc)
  end

  def new
    @quest_form = QuestForm.new(session[:quest] || {})
  end

  def create
    @quest_form = QuestForm.new(quest_params)
    @quest_form.user_id = current_user.id
    @quest_form.xp = (@quest_form.difficulty.to_i * 2)
    @quest_form.public = (@quest_form.public == "1" )

    if @quest_form.save
      session[:quest] = nil
      flash[:notice] = "BranChannelに新たなクエストが作成されました。"
      redirect_to quest_path(@quest_form.id)
    else
      session[:quest] = @quest_form.attributes.slice(*quest_params.keys)
      flash[:alert] = "クエストの作成に失敗しました。"
      redirect_to new_quest_path, flash: { error_title: @quest_form.errors.full_messages_for(:title) }
    end
  end

  def show
    @room = @quest.room
    if !current_user_owned?(@quest) && !public_quest?(@quest)
      flash[:alert] = "公開されていないクエストの詳細を見ることはできません。"
      redirect_to quests_path
    elsif !current_user_owned?(@quest) || (current_user_owned?(@quest) && is_not_own_challenge?(@quest))
      @challenge = Challenge.new
    end
  end

  def edit
    @quest_form = QuestForm.new(session[:edit_quest]) unless session[:edit_quest].nil?
  end

  def update
    if @quest_form.update(quest_params, @quest)
      session[:edit_quest] = nil
      flash[:notice] = "クエストを更新しました。"
      redirect_to quest_path(@quest_form.id)
    else
      session[:edit_quest] = quest_params.to_h.slice(*quest_params.keys)
      flash[:alert] = "クエストの更新に失敗しました。"
      redirect_to edit_quest_path, flash: { error_title: @quest.errors.full_messages_for(:title) }
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
    params.require(:quest_form).permit(:title, :describe, :difficulty, :xp, :public, :name)
  end

  def find_quest
    @quest = Quest.find(params[:id])
  rescue
    flash[:alert] = "クエストが存在していません。"
    redirect_to quests_path
  end

  def find_quest_form
    @quest = Quest.find(params[:id])
    tag_names = @quest.tags.pluck(:name).join(' ')
    tag_hash = { "name" => tag_names }
    form_attributes = @quest.attributes.except("challenge_id", "created_at", "updated_at").merge(tag_hash)
    @quest_form = QuestForm.new(form_attributes)
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
