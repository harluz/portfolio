require 'rails_helper'

RSpec.describe "Pages", type: :system do
  let!(:user) { create(:user) }
  describe "表示確認" do
    context "ヘッダー" do
      context "ユーザーがログインしている場合" do
        it "ログイン後に表示されるリンク等が表示されていること" do
          sign_in user
          visit root_path
          expect(page).to have_content "BranChannel"
          expect(page).to have_content "Home"
          expect(page).to have_content "BranChannelとは"
          expect(page).to have_content "プロフィール"
          expect(page).to have_content "ログアウト"
          expect(page).to have_content "作成"
          expect(page).to have_content "一覧"
          expect(page).to have_content "挑戦中"
          expect(page).to have_link "BranChannel"
          expect(page).to have_link "Home"
          expect(page).to have_link "BranChannelとは"
          expect(page).to have_link "プロフィール"
          expect(page).to have_link "ログアウト"
          expect(page).to have_link "作成"
          expect(page).to have_link "一覧"
          expect(page).to have_link "挑戦中"
          expect(page).not_to have_content "ゲストログイン"
          expect(page).not_to have_content "ログイン"
          expect(page).not_to have_content "新規登録"
          expect(page).not_to have_link "ゲストログイン"
          expect(page).not_to have_link "ログイン"
          expect(page).not_to have_link "新規登録"
        end
      end

      context "ユーザーがログインしていない場合" do
        it "トップページに必要な情報が表示されていること" do
          visit root_path
          expect(page).to have_content "BranChannel"
          expect(page).to have_content "Home"
          expect(page).to have_content "BranChannelとは"
          expect(page).to have_content "ゲストログイン"
          expect(page).to have_content "ログイン"
          expect(page).to have_content "新規登録"
          expect(page).to have_link "BranChannel"
          expect(page).to have_link "Home"
          expect(page).to have_link "BranChannelとは"
          expect(page).to have_link "ゲストログイン"
          expect(page).to have_link "ログイン"
          expect(page).to have_link "新規登録"
          expect(page).not_to have_content "プロフィール"
          expect(page).not_to have_content "ログアウト"
          expect(page).not_to have_content "一覧"
          expect(page).not_to have_content "挑戦中"
          expect(page).not_to have_link "プロフィール"
          expect(page).not_to have_link "ログアウト"
          expect(page).not_to have_link "作成"
          expect(page).not_to have_link "一覧"
          expect(page).not_to have_link "挑戦中"
        end
      end
    end

    context "フッター" do
      it "フッターが表示さていること" do
        visit root_path
        expect(page).to have_content "Copyright © 2023 All Rights Reserved."
      end
    end

    context "/pages/top" do
      before { visit root_path }

      it "トップページに必要な情報が表示されていること" do
        expect(page).to have_content "ようこそBranChannelへ"
        expect(page).to have_content "日々の生活に刺激を感じていますか？"
        expect(page).to have_content "ここでは日々の生活に刺激を与えるため、あなたにはクエストに挑戦していただきます。"
        expect(page).to have_content "クエストはここのユーザー達により作成され、なかにはクエスト達成が難しいものまで様々あります。"
        expect(page).to have_content "経験値を稼いで、最上級の称号を目指してユニークなクエストに挑戦してみましょう"
        expect(page).to have_content "クエストを覗いてみる"
        expect(page).to have_link "クエストを覗いてみる"
      end

      it "タイトルが「BranChannel」になっていること" do
        expect(page).to have_title "BranChannel"
      end
    end

    context "/pages/about" do
      before { visit pages_about_path }

      it "ユーザー登録・ログイン前であってもアクセスできること" do
        expect(current_path).to eq pages_about_path
      end

      it "Aboutページに必要が情報が表示されていること" do
        expect(page).to have_content "BranChannelとは？"
        expect(page).to have_content "使い方"
        expect(page).to have_content "作成"
        expect(page).to have_content "一覧"
        expect(page).to have_content "挑戦中"
      end

      it "タイトルが「BranChannelとは | BranChannel」になっていること" do
        expect(page).to have_title "BranChannelとは | BranChannel"
      end
    end

    context "/pages/profile" do
      let!(:quest1) { create(:quest, user: user, xp: 2) }
      let!(:quest2) { create(:quest, user: user, xp: 2) }
      let!(:quest3) { create(:quest, user: user) }
      let!(:challenge1) { create(:challenge, user: user, quest: quest1) }
      let!(:first_stepper) { create(:first_stepper) }
      let!(:second_stepper) { create(:second_stepper) }
      let!(:noticer) { create(:noticer) }
      let!(:discoverer) { create(:discoverer) }
      let!(:changer) { create(:changer) }
      let!(:challenger) { create(:challenger) }
      let!(:accomplisher) { create(:accomplisher) }
      let!(:legend) { create(:legend) }

      before do
        sign_in user
        visit challenges_path
      end

      it "プロフィール情報が表示されていること" do
        click_on "達成"
        visit pages_profile_path
        expect(page).to have_content user.name
        expect(page).to have_content "称号: #{user.grade}"
        expect(page).to have_content "クエスト作成数"
        expect(page).to have_content "クエスト達成数"
        expect(page).to have_content "獲得経験値"
        expect(page).to have_content "8"
        expect(page).to have_content "3"
        expect(page).to have_link "8"
        expect(page).to have_link "3"
        expect(page).to have_content "102pt"
        expect(page).to have_link "ユーザー編集"
      end

      it "タイトルが「プロフィール | BranChannel」になっていること" do
        visit pages_profile_path
        expect(page).to have_title "プロフィール | BranChannel"
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
          user.grade = "First Stepper"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "First Stepper"
          expect(page).to have_content "Second Stepper"
          expect(page).to have_content "次の称号まで40ポイント"
        end

        it "経験値70ポイント未満はSecond Stepperが表示されていること" do
          user.having_xp = 68
          user.grade = "Second Stepper"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Second Stepper"
          expect(page).to have_content "Noticer"
          expect(page).to have_content "次の称号まで50ポイント"
        end

        it "経験値120ポイント未満はNoticerが表示されていること" do
          user.having_xp = 118
          user.grade = "Noticer"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Noticer"
          expect(page).to have_content "Discoverer"
          expect(page).to have_content "次の称号まで60ポイント"
        end

        it "経験値180ポイント未満はDiscovererが表示されていること" do
          user.having_xp = 178
          user.grade = "Discoverer"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Discoverer"
          expect(page).to have_content "Changer"
          expect(page).to have_content "次の称号まで70ポイント"
        end

        it "経験値250ポイント未満はChangerが表示されていること" do
          user.having_xp = 248
          user.grade = "Changer"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Changer"
          expect(page).to have_content "Challenger"
          expect(page).to have_content "次の称号まで80ポイント"
        end

        it "経験値330ポイント未満はChallengerが表示されていること" do
          user.having_xp = 328
          user.grade = "Challenger"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Challenger"
          expect(page).to have_content "Accomplisher"
          expect(page).to have_content "次の称号まで90ポイント"
        end

        it "経験値420ポイント未満はAccomplisherが表示されていること" do
          user.having_xp = 418
          user.grade = "Accomplisher"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).not_to have_content "Accomplisher"
          expect(page).to have_content "Legend"
          expect(page).to have_content "次の称号まで0ポイント"
        end

        it "経験値420ポイント以上はLegendが表示されていること" do
          user.having_xp = 518
          user.grade = "Legend"
          user.save
          click_on "達成"
          visit pages_profile_path
          expect(page).to have_content "Legend"
          expect(page).to have_content "次の称号まで0ポイント"
        end
      end
    end

    context "/pages/withdraw" do
      it "ユーザー登録・ログインしていない場合アクセスできないこと" do
        visit pages_withdraw_path
        expect(current_path).to eq new_user_session_path
      end

      it "説明文・退会ボタン・キャンセルボタンが表示さていること" do
        sign_in user
        visit pages_withdraw_path
        expect(page).to have_content "ユーザー退会"
        expect(page).to have_content "退会した場合、あなたの挑戦とメッセージは削除されます。"
        expect(page).to have_content "作成したクエストについては、削除されないためご注意ください。"
        expect(page).to have_link "ユーザー退会"
        expect(page).to have_link "キャンセル"
      end

      it "タイトルが「ユーザー退会 | BranChannel」になっていること" do
        sign_in user
        visit pages_withdraw_path
        expect(page).to have_title "ユーザー退会 | BranChannel"
      end
    end
  end

  describe "ページ遷移確認" do
    let!(:first_stepper) { create(:first_stepper) }
    context "ヘッダー" do
      it "ヘッダーのリンクが正しくリダイレクトされていること" do
        visit root_path
        click_on "BranChannel"
        expect(current_path).to eq pages_top_path
        click_on "Home"
        expect(current_path).to eq pages_top_path
        click_on "BranChannelとは"
        expect(current_path).to eq pages_about_path
        click_on "ログイン"
        expect(current_path).to eq new_user_session_path
        click_on "新規登録"
        expect(current_path).to eq new_user_registration_path
        click_on "ゲストログイン"
        expect(current_path).to eq quests_path
        click_on "プロフィール"
        expect(current_path).to eq pages_profile_path
        click_on "作成"
        expect(current_path).to eq new_quest_path
        click_on "一覧"
        expect(current_path).to eq quests_path
        click_on "挑戦中"
        expect(current_path).to eq challenges_path
      end
    end

    context "/pages/profile" do
      let!(:noticer) { create(:noticer) }
      before do
        sign_in user
        visit pages_profile_path
      end

      it "my_questページが表示されること" do
        find("#my-quest-link").click
        expect(current_path).to eq my_quest_quests_path
      end

      it "closed_challengesページが表示されること" do
        find("#closed-challenge-link").click
        expect(current_path).to eq closed_challenges_path
      end

      it "ユーザー編集ページが表示されること" do
        click_on "ユーザー編集"
        expect(current_path).to eq edit_user_registration_path
      end
    end
  end
end
