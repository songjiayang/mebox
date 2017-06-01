class MessagesController < ApplicationController
  def index
    messages = Message.newest.for(current_user_id, params[:reciver_id])
    messages = messages.before(params[:marker]) if params[:marker]
    messages = messages.limit(10)
    render json: messages
  end

  def create
    message = current_user.send_messages.build(create_params)
    message.save

    if message.errors.any?
      render json: { message: message.errors.to_a.first }, status: 500
      return
    end

    # make sure reciver contact with sender
    contact, is_new_record = message.reciver.contact_with!(current_user.name)
    unless contact.nil?
      contact.new_message += 1
      contact.save
    end

    channel_data = contact.attributes
    channel_data[:new_record] = is_new_record
    MessageBus.publish "/contactchannel", channel_data, user_ids: [contact.user_id]
    MessageBus.publish "/chatchannel-#{message.reciver_id}-#{message.sender_id}", message.attributes, user_ids: [message.reciver_id]

    render json: message
  end

  def destroy
    message = current_user.send_messages.find_by(id: params[:id])
    if message.nil?
      render json: { message: "Message not found" }, status: 404
      return
    end

    message.destroy

    if message.errors.any?
      render json: { message: message.errors.to_a.first }, status: 500
      return
    end

    render json: {}
  end

  private

  def create_params
    params
      .require(:message)
      .permit(
        :content, :reciver_id
      )
  end
end
