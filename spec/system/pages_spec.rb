require 'rails_helper'

RSpec.describe "Pages", type: :system do
  let!(:user) { create(:user) }
  describe "表示確認" do
    context "/pages/profile" do
      let!(:quest1) { create(:quest, user: user) }
      let!(:quest2) { create(:quest, user: user) }
      let!(:quest3) { create(:quest, user: user) }
      let!(:challenge1) { create(:challenge, user: user, quest: quest1) }

      before do
        sign_in user
        visit challenges_path
        click_on "達成"
        visit pages_profile_path
      end

      it "プロフィール情報が表示されていること" do
        expect(page).to have_content "ユーザー名"
        expect(page).to have_content "メールアドレス"
        expect(page).to have_content "達成クエスト数(再挑戦を含む)"
        expect(page).to have_content "作成クエスト数"
        expect(page).to have_content "獲得経験値"
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content "1"
        expect(page).to have_content "3"
        expect(page).to have_content "106"
        expect(page).to have_link "ユーザー編集"
      end

      it "数値が３桁区切りとなっていること" do
        user.challenge_achieved = 1000
        user.having_xp = 1000000
        user.save
        visit pages_profile_path
        expect(page).to have_content "1,000"
        expect(page).to have_content "1,000,000"
      end
    end
  end

  describe "ページ遷移確認" do

  end
end
