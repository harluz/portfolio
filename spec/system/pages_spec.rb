require 'rails_helper'

RSpec.describe "Pages", type: :system do
  let!(:user) { create(:user) }
  describe "表示確認" do
    context "/pages/profile" do
      let!(:quest1) { create(:quest, user: user, xp: 2) }
      let!(:quest2) { create(:quest, user: user, xp: 2) }
      let!(:quest3) { create(:quest, user: user) }
      let!(:challenge1) { create(:challenge, user: user, quest: quest1) }
      let!(:first_stepper) { create(:first_stepper)}
      let!(:second_stepper) { create(:second_stepper)}
      let!(:noticer) { create(:noticer)}
      let!(:discoverer) { create(:discoverer)}
      let!(:changer) { create(:changer)}
      let!(:challenger) { create(:challenger)}
      let!(:accomplisher) { create(:accomplisher)}
      let!(:legend) { create(:legend)}

      before do
        sign_in user
        visit challenges_path
      end

      it "プロフィール情報が表示されていること" do
        click_on "達成"
        visit pages_profile_path
        expect(page).to have_content "ユーザー名"
        expect(page).to have_content "メールアドレス"
        expect(page).to have_content "達成クエスト数(再挑戦を含む)"
        expect(page).to have_content "作成クエスト数"
        expect(page).to have_content "獲得経験値"
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content "1"
        expect(page).to have_content "3"
        expect(page).to have_content "102"
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

      context "経験値が増加した場合" do
        it "経験値30ポイント未満はFirst Stepperが表示されていること" do
          user.having_xp = 28
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "First Stepper"
          expect(page).to have_content "Second Stepper"
        end

        it "経験値70ポイント未満はSecond Stepperが表示されていること" do
          user.having_xp = 68
          user.grade = "Second Stepper"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Second Stepper"
          expect(page).to have_content "Noticer"
        end

        it "経験値120ポイント未満はNoticerが表示されていること" do
          user.having_xp = 118
          user.grade = "Noticer"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Noticer"
          expect(page).to have_content "Discoverer"
        end

        it "経験値180ポイント未満はDiscovererが表示されていること" do
          user.having_xp = 178
          user.grade = "Discoverer"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Discoverer"
          expect(page).to have_content "Changer"
        end

        it "経験値250ポイント未満はChangerが表示されていること" do
          user.having_xp = 248
          user.grade = "Changer"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Changer"
          expect(page).to have_content "Challenger"
        end

        it "経験値320ポイント未満はChallengerが表示されていること" do
          user.having_xp = 318
          user.grade = "Challenger"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Challenger"
          expect(page).to have_content "Accomplisher"
        end

        it "経験値400ポイント未満はAccomplisherが表示されていること" do
          user.having_xp = 398
          user.grade = "Accomplisher"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Accomplisher"
          expect(page).to have_content "Legend"
        end

        it "経験値400ポイント以上はLegendが表示されていること" do
          user.having_xp = 498
          user.grade = "Legend"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).to have_content "Legend"
        end
      end
    end
  end

  describe "ページ遷移確認" do
  end
end
