class ChatsController < ApplicationController
  def show
    load_talker or return
    @contact = current_user.contacts
                  .find_by(contacted_id: @talker.name)
    @contact.update_attributes(new_message: 0)
  end

  private

  def load_talker
    @talker = User.find_by(name: params[:cid])
    render json: {}, status: 404 unless @talker
    @talker
  end
end
