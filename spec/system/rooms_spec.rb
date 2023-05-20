require 'rails_helper'

RSpec.describe "Rooms", type: :system do
  let!(:user) { create(:user) }
  before { sign_in user }

  describe "表示確認" do
    let(:quest) { create(:quest, user: user) }
    let!(:room) { create(:room, quest: quest) }

    context "/rooms#show" do
      it "タイトルが「トークルーム  | BranChannel」になっていること" do
        visit quest_room_path(room.quest.id, room.id)
        expect(page).to have_title "トークルーム | BranChannel"
      end

      context "メッセージがある場合" do
        let!(:message) { create(:message, user: user, room: room, created_at: "2023-04-1 12:00:00") }
        it "メッセージが表示されていること" do
          visit quest_room_path(room.quest.id, room.id)
          expect(current_path).to eq quest_room_path(room.quest.id, room.id)
          expect(page).to have_content room.quest.title
          expect(page.body).to include "クエストについて語ってみよう"
          expect(page).to have_content "送信"
          expect(page).to have_button "送信"
          expect(page).to have_content message.content
          expect(page).to have_content "2023/04/01 12:00"
          expect(page).to have_button "コメント削除"
        end
      end

      context "他ユーザーのメッセージがある場合" do
        let(:other_user) { create(:correct_user) }
        let!(:other_message) { create(:message, user: other_user, room: room, created_at: "2023-04-1 12:00:00") }
        it "メッセージが表示され、削除リンクは表示されていないこと" do
          visit quest_room_path(room.quest.id, room.id)
          expect(current_path).to eq quest_room_path(room.quest.id, room.id)
          expect(page).to have_content room.quest.title
          expect(page.body).to include "クエストについて語ってみよう"
          expect(page).to have_content "送信"
          expect(page).to have_content other_message.content
          expect(page).to have_content "2023/04/01 12:00"
          expect(page).not_to have_button "コメント削除"
        end
      end

      context "存在しないトークルームにアクセスする場合" do
        let(:quest) { create(:quest, user: user) }

        it "フラッシュメッセージが表示され、クエスト一覧ページにリダイレクトしていること" do
          visit quest_room_path(quest, 0)
          expect(page).to have_content "クエストもしくはトークルームが存在していません。"
          expect(current_path).to eq quests_path
        end
      end

      context "他ユーザーの非公開クエストのトークルームにアクセスする場合" do
        let(:other_user) { create(:correct_user) }
        let(:non_public_quest) { create(:non_public_quest, user: other_user) }
        let!(:non_public_room) { create(:room, quest: non_public_quest) }

        it "フラッシュメッセージが表示され、クエスト一覧ページにリダイレクトしていること" do
          visit quest_room_path(non_public_room.quest, non_public_room)
          expect(page).to have_content "非公開クエストのトークルームにアクセスすることはできません。"
          expect(current_path).to eq quests_path
        end
      end
    end
  end
  describe "ページ遷移確認" do
  end
  describe "room新規作成" do
    before do
      visit new_quest_path
      fill_in 'タイトル', with: "Create a quest you want to complete."
      fill_in 'クエスト詳細', with: "Create quest achievement conditions."
      choose('radio-3')
      check "quest_form[public]"
      click_on "クエスト作成"
    end

    it "questのshowページ内にリンクが生成され、roomにアクセスできること" do
      quest = Quest.first
      visit quest_path(quest)
      expect(page).to have_content "トークルームへ"
      expect(page).to have_link "トークルームへ"
      click_on "トークルームへ"
      expect(current_path).to eq quest_room_path(quest, Room.first)
      expect(page).to have_content quest.title
      expect(page.body).to include "クエストについて語ってみよう"
      expect(page).to have_button "送信"
    end
  end

  describe "room削除" do
    let!(:quest) { create(:quest, user: user) }
    let!(:room) { create(:room, quest: quest) }

    it "クエストの削除と同時にトークルームも削除されていること" do
      quest.destroy
      visit quest_room_path(quest, room)
      expect(current_path).to eq quests_path
      expect(page).to have_content "クエストもしくはトークルームが存在していません。"
    end
  end
end
