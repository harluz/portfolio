require 'rails_helper'

RSpec.describe "Challenges", type: :system do
  let!(:user) { create(:user) }
  let(:other_user) { create(:correct_user) }
  let(:public_quest) { create(:public_quest, user: user) }
  let(:non_public_quest) { create(:non_public_quest, user: user) }
  let(:other_public_quest) { create(:public_other_quest, user: other_user) }
  let(:other_non_public_quest) { create(:other_quest, user: other_user) }
  let!(:room) { create(:room, quest: public_quest) }
  let!(:non_public_room) { create(:room, quest: non_public_quest) }
  let!(:other_room) { create(:room, quest: other_public_quest) }
  let!(:first_stepper) { create(:first_stepper) }
  let!(:second_stepper) { create(:second_stepper) }
  let!(:noticer) { create(:noticer) }
  let!(:discoverer) { create(:discoverer) }
  let!(:changer) { create(:changer) }
  let!(:challenger) { create(:challenger) }
  let!(:accomplisher) { create(:accomplisher) }
  let!(:legend) { create(:legend) }

  before { sign_in user }

  describe "表示確認" do
    let(:complete_quest) { create(:quest, title: "This is a quest to complete", user: user) }
    let(:give_up_quest) { create(:quest, title: "This is a quest to give up", user: user) }

    context "/challenge#index" do
      it "タイトルが「挑戦一覧  | BranChannel」になっていること" do
        visit challenges_path
        expect(page).to have_title "挑戦一覧 | BranChannel"
      end

      context "挑戦中クエストがある場合" do
        let!(:complete_challenge) { create(:challenge, user: user, quest: complete_quest) }
        let!(:give_up_challenge) { create(:challenge, user: user, quest: give_up_quest) }
        it "自身の挑戦中のクエストが表示されていること" do
          visit challenges_path
          expect(page).not_to have_content "挑戦中のクエストがありません"
          expect(page).to have_content complete_challenge.quest.title
          expect(page).to have_content give_up_challenge.quest.title
          expect(page).to have_content "詳細"
          expect(page).to have_button "達成"
          expect(page).to have_content "諦める"
          within(".challenge_#{complete_challenge.id}") do
            click_on "達成"
          end
          within(".challenge_#{give_up_challenge.id}") do
            click_on "諦める"
          end
          visit challenges_path
          expect(page).not_to have_content complete_challenge.quest.title
          expect(page).not_to have_content give_up_challenge.quest.title
          expect(page).not_to have_content "詳細"
          expect(page).not_to have_button "達成"
          expect(page).not_to have_content "諦める"
        end
      end

      context "挑戦中クエストがない場合" do
        it "挑戦中のクエストがないコメントが表示されていること" do
          visit challenges_path
          expect(page).to have_content "挑戦中のクエストがありません"
        end
      end

      context "他ユーザーの公開クエストが非公開となった場合" do
        it "挑戦中であったものは表示されていること" do
          visit quest_path(other_public_quest)
          click_on "挑戦"
          other_public_quest.public = false
          other_public_quest.save
          visit challenges_path
          expect(page).to have_content other_public_quest.title
          expect(page).to have_content "クエストが非公開となりました"
          expect(page).to have_button "達成"
          expect(page).to have_content "諦める"
        end
      end

      context "他ユーザーの公開クエストが削除された場合" do
        it "挑戦中であっても、削除されたクエストは削除されたメッセージが表示されること" do
          visit quest_path(other_public_quest)
          click_on "挑戦"
          other_public_quest.public = false
          other_public_quest.save
          other_public_quest.destroy
          visit challenges_path
          expect(page).to have_content "作成者によりクエストが削除されました。"
          expect(page).to have_content "リストから削除"
          expect(page).not_to have_content other_public_quest.title
          expect(page).not_to have_content "クエストが非公開となりました"
          expect(page).not_to have_button "達成"
          expect(page).not_to have_content "諦める"
        end
      end
    end

    context "/challenge#closed" do
      it "タイトルが「達成一覧  | BranChannel」になっていること" do
        visit closed_challenges_path
        expect(page).to have_title "達成一覧 | BranChannel"
      end

      context "クエストが達成される場合" do
        let!(:complete_challenge) { create(:challenge, user: user, quest: complete_quest) }
        let!(:give_up_challenge) { create(:challenge, user: user, quest: give_up_quest) }
        it "達成したクエストが表示されていること" do
          visit closed_challenges_path
          expect(page).not_to have_content complete_challenge.quest.title
          expect(page).not_to have_content give_up_challenge.quest.title
          expect(page).not_to have_content "詳細"
          expect(page).not_to have_button "再挑戦"
          expect(page).to have_content "達成したクエストがありません"
          visit challenges_path
          within(".challenge_#{complete_challenge.id}") do
            click_on "達成"
          end
          within(".challenge_#{give_up_challenge.id}") do
            click_on "諦める"
          end
          visit closed_challenges_path
          expect(page).to have_content complete_challenge.quest.title
          expect(page).to have_content "詳細"
          expect(page).to have_button "再挑戦"
          expect(page).not_to have_content give_up_challenge.quest.title
        end
      end

      context "達成済みの他ユーザー公開クエストが非公開となった場合" do
        it "達成したクエストは表示されていること" do
          visit quest_path(other_public_quest)
          click_on "挑戦"
          visit challenges_path
          click_on "達成"
          other_public_quest.public = false
          other_public_quest.save
          visit closed_challenges_path
          expect(page).to have_content other_public_quest.title
          expect(page).to have_content "クエストが非公開となりました"
          expect(page).not_to have_button "再挑戦"
          expect(page).not_to have_content "詳細"
        end
      end

      context "達成済みの他ユーザー公開クエストが削除された場合" do
        it "達成済みであっても、削除されたクエストは削除されたメッセージが表示されること" do
          visit quest_path(other_public_quest)
          click_on "挑戦"
          visit challenges_path
          click_on "達成"
          other_public_quest.public = false
          other_public_quest.save
          other_public_quest.destroy
          visit closed_challenges_path
          expect(page).to have_content "作成者によりクエストが削除されました。"
          expect(page).to have_content "リストから削除"
          expect(page).not_to have_content other_public_quest.title
          expect(page).not_to have_button "再挑戦"
          expect(page).not_to have_content "詳細"
        end
      end
    end
  end

  describe "challenge新規作成" do
    context "自身のクエストの場合" do
      before do
        visit new_quest_path
        fill_in 'タイトル', with: "Create a quest you want to complete."
        fill_in 'クエスト詳細', with: "Create quest achievement conditions."
        choose('radio-3')
      end

      it "公開クエスト作成と同時にchallengeも作成されていること" do
        check "quest_form[public]"
        click_on "クエスト作成"
        visit challenges_path
        expect(page).to have_content "Create a quest you want to complete."
      end

      it "非公開クエスト作成と同時にchallengeも作成されていること" do
        uncheck "quest_form[public]"
        click_on "クエスト作成"
        visit challenges_path
        expect(page).to have_content "Create a quest you want to complete."
      end

      it "自身のクエストを諦めても再挑戦することができること" do
        check "quest_form[public]"
        click_on "クエスト作成"
        visit challenges_path
        click_on "諦める"
        visit quest_path(user.quests.last)
        click_on "挑戦"
        expect(current_path).to eq challenges_path
        expect(page).to have_content "挑戦リストに追加されました。"
        expect(page).to have_content "Create a quest you want to complete."
      end

      it "自身の一度達成したクエストにclosed_challenges_pathから再挑戦することができる" do
        uncheck "quest_form[public]"
        click_on "クエスト作成"
        visit challenges_path
        click_on "達成"
        visit closed_challenges_path
        click_on "再挑戦"
        expect(current_path).to eq challenges_path
        expect(page).to have_content "挑戦リストに追加されました。"
        expect(page).to have_content "Create a quest you want to complete."
      end
    end

    context "他ユーザーの公開クエストの場合" do
      let!(:other_quest) { create(:public_other_quest, user: other_user) }
      let!(:room) { create(:room, quest: other_quest) }

      before do
        visit quest_path(other_quest)
        click_on "挑戦"
      end

      it "クエストに挑戦できること" do
        expect(current_path).to eq challenges_path
        expect(page).to have_content "挑戦リストに追加されました。"
        expect(page).to have_content other_quest.title
      end

      it "他ユーザーの公開クエストを諦めても再挑戦することができること" do
        click_on "諦める"
        visit quest_path(other_quest)
        click_on "挑戦"
        expect(current_path).to eq challenges_path
        expect(page).to have_content "挑戦リストに追加されました。"
        expect(page).to have_content other_quest.title
      end

      it "他ユーザーの一度達成した公開クエストにclosed_challenges_pathから再挑戦することができる" do
        click_on "達成"
        visit closed_challenges_path
        click_on "再挑戦"
        expect(current_path).to eq challenges_path
        expect(page).to have_content "挑戦リストに追加されました。"
        expect(page).to have_content other_quest.title
      end
    end

    context "他ユーザーの公開クエストが非公開となった場合" do
      it "達成後、再挑戦できないこと" do
        visit quest_path(other_public_quest)
        click_on "挑戦"
        other_public_quest.public = false
        other_public_quest.save
        visit challenges_path
        click_on "達成"
        visit closed_challenges_path
        expect(page).to have_content other_public_quest.title
        expect(page).to have_content "クエストが非公開となりました"
        expect(page).not_to have_button "再挑戦"
        expect(page).not_to have_content "詳細"
      end
    end
  end

  describe "challenge編集" do
    context "更新に成功する場合" do
      let!(:public_quest_challenge) { create(:challenge, user: user, quest: public_quest) }
      let!(:non_public_quest_challenge) { create(:challenge, user: user, quest: non_public_quest) }
      let!(:other_public_quest_challenge) { create(:challenge, user: user, quest: other_public_quest) }

      before { visit challenges_path }

      it "自身の公開クエストを達成することができる" do
        within(".challenge_#{public_quest_challenge.id}") do
          click_on "達成"
        end
        expect(current_path).to eq challenges_path
        expect(page).to have_content "クエスト達成おめでとうございます。経験値#{public_quest_challenge.quest.xp}ポイントを獲得しました。"
        expect(page).not_to have_content public_quest_challenge.quest.title
      end

      it "自身の非公開クエストを達成することができる" do
        within(".challenge_#{non_public_quest_challenge.id}") do
          click_on "達成"
        end
        expect(current_path).to eq challenges_path
        expect(page).to have_content "クエスト達成おめでとうございます。経験値#{non_public_quest_challenge.quest.xp}ポイントを獲得しました。"
        expect(page).not_to have_content non_public_quest_challenge.quest.title
      end

      it "他ユーザーの公開クエストを達成することができる" do
        within(".challenge_#{other_public_quest_challenge.id}") do
          click_on "達成"
        end
        expect(current_path).to eq challenges_path
        expect(page).to have_content "クエスト達成おめでとうございます。経験値#{other_public_quest_challenge.quest.xp}ポイントを獲得しました。"
        expect(page).not_to have_content other_public_quest_challenge.quest.title
      end
    end

    context "他ユーザーの公開クエストが非公開となった場合" do
      it "挑戦中であったものは達成できること" do
        visit quest_path(other_public_quest)
        click_on "挑戦"
        other_public_quest.public = false
        other_public_quest.save
        visit challenges_path
        click_on "達成"
        expect(current_path).to eq challenges_path
        expect(page).to have_content "クエスト達成おめでとうございます。経験値#{other_public_quest.xp}ポイントを獲得しました。"
        expect(page).not_to have_content other_public_quest.title
      end
    end
  end

  describe "challenge削除" do
    context "削除に成功する場合" do
      let!(:public_quest_challenge) { create(:challenge, user: user, quest: public_quest) }
      let!(:non_public_quest_challenge) { create(:challenge, user: user, quest: non_public_quest) }
      let!(:other_public_quest_challenge) { create(:challenge, user: user, quest: other_public_quest) }
      let!(:other_non_public_quest_challenge) { create(:challenge, user: user, quest: other_non_public_quest) }

      before { visit challenges_path }

      it "自身の公開クエストを諦めることができる" do
        within(".challenge_#{public_quest_challenge.id}") do
          click_on "諦める"
        end
        expect(current_path).to eq challenges_path
        expect(page).to have_content "挑戦リストから削除しました。"
        expect(page).not_to have_content public_quest_challenge.quest.title
      end

      it "自身の非公開クエストを諦めることができる" do
        within(".challenge_#{non_public_quest_challenge.id}") do
          click_on "諦める"
        end
        expect(current_path).to eq challenges_path
        expect(page).to have_content "挑戦リストから削除しました。"
        expect(page).not_to have_content non_public_quest_challenge.quest.title
      end

      it "他ユーザーの公開クエストを諦めることができる" do
        within(".challenge_#{other_public_quest_challenge.id}") do
          click_on "諦める"
        end
        expect(current_path).to eq challenges_path
        expect(page).to have_content "挑戦リストから削除しました。"
        expect(page).not_to have_content other_public_quest_challenge.quest.title
      end

      it "他ユーザーの公開クエストが非公開になったクエストを諦めることができる" do
        within(".challenge_#{other_non_public_quest_challenge.id}") do
          click_on "諦める"
        end
        expect(current_path).to eq challenges_path
        expect(page).to have_content "挑戦リストから削除しました。"
        expect(page).not_to have_content other_non_public_quest_challenge.quest.title
      end
    end

    context "他ユーザーの公開クエストが削除された場合" do
      it "挑戦中だったクエストはリストから削除することができる" do
        visit quest_path(other_public_quest)
        click_on "挑戦"
        other_public_quest.public = false
        other_public_quest.save
        other_public_quest.destroy
        visit challenges_path
        click_on "リストから削除"
        expect(current_path).to eq challenges_path
        expect(page).to have_content "挑戦リストから削除しました。"
        expect(page).not_to have_content other_public_quest.title
      end
    end

    context "達成済みの他ユーザー公開クエストが削除された場合" do
      it "達成済みであっても、削除されたクエストはリストから削除することができる" do
        visit quest_path(other_public_quest)
        click_on "挑戦"
        visit challenges_path
        click_on "達成"
        other_public_quest.public = false
        other_public_quest.save
        other_public_quest.destroy
        visit closed_challenges_path
        click_on "リストから削除"
        expect(current_path).to eq challenges_path
        expect(page).to have_content "挑戦リストから削除しました。"
        expect(page).not_to have_content other_public_quest.title
      end
    end
  end
end
