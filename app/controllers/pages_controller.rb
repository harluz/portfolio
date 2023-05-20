class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]

  def top
  end

  def about
  end

  def profile
    @user = current_user
  end

  def withdraw
    @user = current_user
  end
end
