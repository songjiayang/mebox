class MessagesController < ApplicationController

  def index
    messages = Message.newest.for(current_user_id, params[:reciver_id])
    messages = messages.before(params[:marker]) if params[:marker]
    messages = messages.limit(10)
    render json: messages
  end

  def create
    message = current_user.send_messages.build(create_params)
    if message.save
      ChatChannel.publish message
      ContactChannel.publish message.notice_contact, new_record: message.notice_contact_created
      render json: message
    else
      render json: { message: message.errors.to_a.first }, status: 500
    end
  end

  def destroy
    load_message or return
    
    if @message.destroy
      ChatChannel.publish @message, { deleted: true }
      render json: {}
    else
      render json: { message: @message.errors.to_a.first }, status: 500
    end
  end

  private

  def create_params
    params
      .require(:message)
      .permit(
        :content, :reciver_id
      )
  end

  def load_message
    @message = current_user.send_messages.find_by(id: params[:id])
    unless @message
      render json: { message: "Message not found" }, status: 404
    end
    @message
  end
end
