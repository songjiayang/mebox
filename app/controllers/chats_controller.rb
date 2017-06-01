class ChatsController < ApplicationController
  def show
    @talker = User.find_by(name: params[:cid])
    if @talker.nil?
      render status: 404
      return
    end

    # just refresh contact new_message
    @contact = current_user.contacts
                  .find_by(contacted_id: @talker.name)
    @contact.update_attributes(new_message: 0)
  end
end
