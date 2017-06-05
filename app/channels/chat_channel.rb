class ChatChannel
  class << self
    def publish(message, opts={})
      MessageBus.publish channel_id(message),
        message.attributes.merge(opts),
        user_ids: [message.reciver_id]
    end

    private

    def channel_id(message)
      "/chat-channel-#{message.reciver_id}-#{message.sender_id}"
    end
  end
end
