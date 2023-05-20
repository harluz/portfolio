require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let!(:user) { create(:user) }
  let!(:quest) { create(:quest, user: user) }
  let!(:room) { create(:room, id: 1, quest_id: quest.id) }

  context "speak action" do
    let(:other_user) { create(:correct_user) }
    let(:message) { create(:message, user: other_user, room: room) }
    before do
      stub_connection current_user: user
      subscribe(room: room.id)
    end

    it 'room_channelに接続されていること' do
      expect(subscription).to be_confirmed
    end

    it 'speakアクションでmessageが作成されていること' do
      expect do
        perform(:speak, message: 'Hello, world!')
      end.to change(Message, :count).by(1)

      expect(Message.last.content).to eq('Hello, world!')
      expect(Message.last.user_id).to eq(user.id)
      expect(Message.last.room_id).to eq(room.id)
    end

    it 'メッセージを作成し、正しいチャネルにブロードキャストされていること' do
      expect do
        perform(:speak, message: 'Hello, world!', room_id: room.id)
        sleep 3
      end.to have_broadcasted_to("room_channel_#{room.id}").
        with { |data| expect(data["messagecurrent"]).to match(/Hello, world!/) }
    end

    it '他のユーザーのメッセージがブロードキャストされていること' do
      expect do
        perform(:destroy, id: message.id)
        sleep 3
      end.to have_broadcasted_to("room_channel_#{room.id}").
        with { |data| expect(data['messageother']).to include(message.content) }
    end
  end

  context "destroy ation" do
    let!(:message) { create(:message, user: user, room: room) }
    before do
      stub_connection current_user: user
      subscribe(room: room.id)
    end

    it 'メッセージの削除がブロードキャストされていること' do
      expect do
        perform(:destroy, id: message.id)
        sleep 3
      end.to have_broadcasted_to("room_channel_#{room.id}").
        with { |data| expect(data['id']).to eq(message.id) }
    end

    it 'destroyアクションでmessageが削除されていること' do
      expect do
        perform(:destroy, id: message.id)
      end.to change(Message, :count).by(-1)

      expect(Message.find_by(id: message.id)).to be_nil
      expect do
        perform(:destroy, id: 0)
      end.not_to change(Message, :count)
    end
  end
end
