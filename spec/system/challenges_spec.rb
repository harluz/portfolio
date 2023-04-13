require 'rails_helper'

RSpec.describe "Challenges", type: :system do
  let!(:user) { create(:user) }
  before { sign_in user }
  
  describe "表示確認" do
    let(:complete_quest) { create(:quest, title: "This is a quest to complete", user: user) }
    let(:give_up_quest) { create(:quest, title: "This is a quest to give up", user: user) }

    context  "/challenge#index" do
      context  "挑戦中クエストがある場合" do
        let!(:complete_challenge) { create(:challenge, user_id: user.id, quest_id: complete_quest.id)}
        let!(:give_up_challenge) { create(:challenge, user_id: user.id, quest_id: give_up_quest.id)}
        it "自身の挑戦中のクエストが表示されていること" do
          visit challenges_path
          expect(page).not_to have_content "挑戦中のクエストがありません"
          expect(page).to have_content complete_challenge.quest.title
          expect(page).to have_content give_up_challenge.quest.title
          expect(page).to have_content "詳細"
          expect(page).to have_button "達成"
          expect(page).to have_content "諦める"
          complete_challenge.close = true
          complete_challenge.save
          give_up_challenge.destroy
          visit challenges_path
          expect(page).not_to have_content complete_challenge.quest.title
          expect(page).not_to have_content give_up_challenge.quest.title
          expect(page).not_to have_content "詳細"
          expect(page).not_to have_button "達成"
          expect(page).not_to have_content "諦める"
        end
      end

      context  "挑戦中クエストがない場合" do
        it "挑戦中のクエストがないコメントが表示されていること" do
          visit challenges_path
          expect(page).to have_content "挑戦中のクエストがありません"
        end
      end
    end

    context  "/challenge#closed" do
      let!(:complete_challenge) { create(:challenge, user_id: user.id, quest_id: complete_quest.id)}
      let!(:give_up_challenge) { create(:challenge, user_id: user.id, quest_id: give_up_quest.id)}
      it "達成したクエストが表示されていること" do
        visit closed_challenges_path
        expect(page).not_to have_content complete_challenge.quest.title
        expect(page).not_to have_content give_up_challenge.quest.title
        expect(page).not_to have_content "詳細"
        expect(page).not_to have_button "再挑戦"
        expect(page).to have_content "達成したクエストがありません"
        complete_challenge.close = true
        complete_challenge.save
        give_up_challenge.destroy
        visit closed_challenges_path
        expect(page).to have_content complete_challenge.quest.title
        expect(page).to have_content "詳細"
        expect(page).to have_button "再挑戦"
        expect(page).not_to have_content give_up_challenge.quest.title
      end
    end
  end

  describe "ページ遷移確認" do
  end

  describe "challenge新規作成" do
    context "作成に成功する場合" do
      context "自身のクエストの場合" do
        it "公開クエスト作成と同時にchallengeも作成されていること" do
          visit new_quest_path
          fill_in 'タイトル', with: "Create a quest you want to complete."
          fill_in 'クエスト詳細', with: "Create quest achievement conditions."
          choose('quest_difficulty_3')
          check "quest_public"
          click_on "クエスト作成！"
          visit challenges_path
          expect(page).to have_content "Create a quest you want to complete."
        end
  
        it "非公開クエスト作成と同時にchallengeも作成されていること" do
          visit new_quest_path
          fill_in 'タイトル', with: "Create a quest you want to complete."
          fill_in 'クエスト詳細', with: "Create quest achievement conditions."
          choose('quest_difficulty_3')
          uncheck "quest_public"
          click_on "クエスト作成！"
          visit challenges_path
          expect(page).to have_content "Create a quest you want to complete."
        end

        it "自身のクエストを諦めても再挑戦することができること" do
          visit new_quest_path
          fill_in 'タイトル', with: "Create a quest you want to complete."
          fill_in 'クエスト詳細', with: "Create quest achievement conditions."
          choose('quest_difficulty_3')
          check "quest_public"
          click_on "クエスト作成！"
          visit challenges_path
          click_on "諦める"
          visit quest_path(user.quests.last)
          click_on "挑戦する"
          expect(current_path).to eq challenges_path
          expect(page).to have_content "挑戦リストに追加されました。"
        end

        it "自身の一度達成したクエストにclosed_challenges_pathから再挑戦することができる" do
          visit new_quest_path
          fill_in 'タイトル', with: "Create a quest you want to complete."
          fill_in 'クエスト詳細', with: "Create quest achievement conditions."
          choose('quest_difficulty_3')
          uncheck "quest_public"
          click_on "クエスト作成！"
          visit challenges_path
          click_on "達成"
          visit closed_challenges_path
          click_on "再挑戦"
          expect(current_path).to eq challenges_path
          expect(page).to have_content "挑戦リストに追加されました。"
        end
        # 自身の一度達成したクエストにquests_pathから再挑戦することができる
      end

      context "他ユーザーの公開クエストの場合" do
        let(:other_user) { create(:correct_user) }
        let!(:other_quest) { create(:other_quest, public: true, user: other_user) }
        it "クエストに挑戦できること" do
          visit quest_path(other_quest)
          click_on "挑戦する"
          visit challenges_path
          expect(page).to have_content other_quest.title
        end
        # 他ユーザーの公開クエストを諦めても再挑戦することができること
        # 他ユーザーの一度達成した公開クエストにclosed_challenges_pathから再挑戦することができる
        # 他ユーザーの一度達成した公開クエストにquests_pathから再挑戦することができる
      end
    end
  
    context "作成に失敗する場合" do
      # 他ユーザーの非公開クエストに挑戦できないこと
      # 自身のクエストで挑戦中のクエストに重ねて挑戦できないこと
      # 他ユーザーの公開クエストで挑戦中のクエストに重ねて挑戦できないこと
    end
  end

  describe "challenge編集" do
    context "更新に成功する場合" do
      # 自身の公開クエストを達成することができる
      # 自身の非公開クエストを達成することができる
      # 他ユーザーの公開クエストを達成することができる
    end

    context "更新に失敗する場合" do
    end
  end

  describe "challenge削除" do
    context "削除に成功する場合" do
      # 自身の公開クエストを諦めることができる
      # 自身の非公開クエストを諦めることができる
      # 他ユーザーの公開クエストを諦めることができる
    end
  end
end
