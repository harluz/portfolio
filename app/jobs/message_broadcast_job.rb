class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "room_channel_#{message.room_id}", { messagecurrent: render_message(message), messageother: render_messageother(message), message_user: @arguments[0].user_id }
  end

  private

  def render_message(message)
    ApplicationController.render_with_signed_in_user(message.user, partial: 'messages/messagecurrent', locals: { message: message })
  end

  def render_messageother(message)
    ApplicationController.render_with_signed_in_user(message.user, partial: 'messages/messageother', locals: { message: message })
  end
end
