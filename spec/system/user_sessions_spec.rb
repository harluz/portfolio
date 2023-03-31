require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  describe "テスト疎通確認" do
    before do
      visit new_user_session_path
    end

    it "ログインの文字が表示されていること" do
      expect(page).to have_content "Log in"
    end
  end
end
