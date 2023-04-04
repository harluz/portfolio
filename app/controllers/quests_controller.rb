class QuestsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
  end

  def new
    @quest = Quest.new(session[:quest] || {} )
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
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def quest_params
    params.require(:quest).permit(:title, :describe, :difficulty, :public)
  end
end
