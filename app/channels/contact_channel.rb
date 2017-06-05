class ContactChannel
  class << self
    def publish(contact, opts={})
      MessageBus.publish channel_id,
        contact.attributes.merge(opts),
        user_ids: [contact.user_id]
    end

    private

    def channel_id
      "/contact-channel"
    end
  end
end
