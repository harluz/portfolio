class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params['room']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create!(content: data['message'], user_id: current_user.id, room_id: params['room'])
  end

  def destroy(data)
    @message = Message.find_by(id: data['id'])
    if @message.user == current_user
      @message.destroy
      ActionCable.server.broadcast "room_channel_#{params['room']}", { id: data['id'] }
    end
  end
end
