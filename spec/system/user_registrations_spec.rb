require 'rails_helper'

RSpec.describe "UserRegistrations", type: :system do
  describe "テスト疎通確認" do
    before do
      visit new_user_registration_path
    end

    it "サインアップのフォームが表示されていること" do
      expect(page).to have_content "Name"
    end
  end
end
