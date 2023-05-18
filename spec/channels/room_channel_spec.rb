require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let!(:user) { create(:user) }
  let!(:quest) { create(:quest, user: user) }
  let!(:room) { create(:room, id: 1, quest_id: quest.id) }
  let!(:message) { create(:message, user: user, room: room) }

  before do
    stub_connection current_user: user
    subscribe(room: room.id)
  end

  it 'room_channelに接続されていること' do
    expect(subscription).to be_confirmed
  end

  it 'メッセージを作成し、正しいチャネルにブロードキャストされていること' do
    expect {
      perform(:speak, message: 'Hello, world!')
      sleep 3
    }.to have_broadcasted_to("room_channel_#{room.id}")
       .with { |data| expect(data[:message]).to match(/Hello, world!/) }
  end

  it 'speakアクションでmessageが作成されていること' do
    expect {
      perform(:speak, message: 'Hello, world!')
    }.to change(Message, :count).by(1)

    expect(Message.last.content).to eq('Hello, world!')
    expect(Message.last.user_id).to eq(user.id)
    expect(Message.last.room_id).to eq(room.id)
  end

  it 'destroyアクションでmessageが削除されていること' do
    expect {
      perform(:destroy, id: message.id)
    }.to change(Message, :count).by(-1)
  
    expect(Message.find_by(id: message.id)).to be_nil
    expect {
      perform(:destroy, id: 0)
    }.not_to change(Message, :count)
  end
end
