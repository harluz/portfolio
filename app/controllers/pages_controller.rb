class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:top]

  def top
  end

  def main
  end

  def profile
    @user = current_user
  end

  def withdraw
    @user = current_user
  end
end
