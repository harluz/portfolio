require 'rails_helper'

RSpec.describe "Messages", type: :system do
  let!(:user) { create(:user) }
  let(:other_user) { create(:correct_user) }
  let(:public_quest) { create(:public_quest, user: user) }
  # let(:other_public_quest) { create(:public_other_quest, user: other_user) }
  let!(:public_room) { create(:room, quest: public_quest) }
  # let!(:other_room) { create(:room, quest: other_public_quest) }

  before { sign_in user }

  describe "表示確認" do
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

  describe "message新規作成" do
    # it "メッセージの送信に成功する場合", js: true do
    #   visit quest_path(public_quest)
    #   click_on "トークルームへ"
    #   fill_in "message-textarea", with: "新規メッセージ作成"
    #   click_on "コメントを送信"
    #   sleep 5
    #   visit quest_room_path(public_quest, public_room)
    #   expect(page).to have_content "新規メッセージ作成"
    # end
  end

  describe "message削除" do
    let!(:quest) { create(:quest, user: user) }
    let(:room) { create(:room, quest: quest) }
    let!(:message) { create(:message, user: user, room: room, created_at: "2023-04-1 12:00:00") }

    context "自身のメッセージを削除する場合" do
      # it "削除に成功すること" do
      #   visit quest_room_path(quest, room)
      #   click_on "コメントを削除"
      #   sleep 5
      #   visit quest_room_path(quest, room)
      #   expect(page).not_to have_content message.content
      #   expect(page).not_to have_content "2023/04/01 12:00"
      #   expect(page).not_to have_button "コメントを削除"
      # end
    end

    it "クエストの削除と同時にメッセージも削除されていること" do
      visit my_quest_quests_path
      click_on "削除"
      expect(user.messages.blank?).to eq true
    end
  end
end
