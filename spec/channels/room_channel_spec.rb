require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let!(:user) { create(:user) }
  let(:quest) { create(:quest, user: user) }
  let(:room) { create(:room, quest_id: quest.id) }

  before do
    sign_in user
    stub_connection
  end

  describe "メッセージの送信" do
    let(:message) { build(:message, user: user, room_id: room.id) }

    context "送信成功" do
      # it "メッセージがDBに保存されていること" do
      #   subscribe(room_id: room.id)
      #   expect(subscription).to be_confirmed
      #   expect do
      #     perform :speak, message: message.content
      #   end.to change(Message, :count).by(1)
      # end
    end
  end
end
