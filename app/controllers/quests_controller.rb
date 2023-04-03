class QuestsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
  end

  def new
    @quest = Quest.new
  end

  def create
    @quest = Quest.new(quest_params)
    @quest.user_id = current_user.id
    @quest.xp = @quest.set_xp
    
    binding.pry
    
    if @quest.save
      flash[:notice] = "BranChannelに新たなクエストが作成されました。"
      redirect_to quest_path(@quest)
    else
      flash[:alert] = "クエストの作成に失敗しました。"
      render "new"
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
