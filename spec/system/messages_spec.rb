require 'rails_helper'

RSpec.describe "Messages", type: :system do
  let!(:user) { create(:user) }
  let(:other_user) { create(:correct_user) }
  let(:public_quest) { create(:public_quest, user: user) }
  let!(:public_room) { create(:room, quest: public_quest) }

  before { sign_in user }

  describe "表示確認" do
    it "クエストタイトル、送信・戻るボタンが表示されていること" do
      visit quest_room_path(public_quest, public_room)
      expect(page).to have_content public_quest.title
      expect(page).to have_content "送信"
      expect(page).to have_content "戻る"
      expect(page).to have_button "送信"
      expect(page).to have_link "戻る"
    end

    context "自身のメッセージの場合" do
      let!(:message) { create(:message, user: user, room: public_room, created_at: "2023-04-1 12:00:00") }
      it "メッセージ。日時、削除ボタンが表示されること" do
        visit quest_room_path(public_quest, public_room)
        expect(page).to have_content message.content
        expect(page).to have_content "2023/04/01 12:00"
        expect(page).to have_button "コメント削除"
      end
    end

    context "他ユーザーのメッセージの場合" do
      let!(:other_message) { create(:message, user: other_user, room: public_room, created_at: "2023-04-1 12:00:00") }
      it "メッセージ、日時が表示されること" do
        visit quest_room_path(public_quest, public_room)
        expect(page).to have_content other_message.content
        expect(page).to have_content "2023/04/01 12:00"
        expect(page).not_to have_button "コメント削除"
      end
    end
  end

  describe "message削除" do
    let!(:quest) { create(:quest, user: user) }
    let(:room) { create(:room, quest: quest) }
    let!(:message) { create(:message, user: user, room: room, created_at: "2023-04-1 12:00:00") }

    it "クエストの削除と同時にメッセージも削除されていること" do
      visit my_quest_quests_path
      click_on "削除"
      expect(user.messages.blank?).to eq true
    end
  end
end
