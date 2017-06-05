class ContactsController < ApplicationController
  def index
    @page_size = 25
    respond_to do |format|
       format.json {
         @contacts = current_user.contacts.newest
         @contacts = @contacts.before(params[:marker].to_i) if params[:marker]
         @contacts = @contacts.limit(@page_size)
         render json: @contacts
       }
       format.html
    end
  end

  def create
    build_contact or return
    if @contact.save
      render json: @contact
    else
      render json: { message: @contact.errors.to_a.first }, status: 500
    end
  end

  def update
    load_contact or return
    @contact.update_attributes(new_message: 0)
    render json: {}
  end

  def destroy
    load_contact or return

    if @contact.destroy
      render json: { message: "Contact deleted successful" }
    else
      render json: { message: @contact.errors.to_a.first }, status: 500
    end
  end

  private

  def load_contact
    @contact = current_user.contacts.find_by(id: params[:id])
    render json: { message: "Contact not found" }, status: 404 unless @contact
    @contact
  end

  def build_contact
    if params[:contacted_id] == current_user.name
      render json: { message: "Unable to add yourself to your Contacts"}, status: 400
      return
    end

    unless User.where(name: params[:contacted_id]).exists?
      render json: { message: "User not found"}, status: 400
      return
    end

    @contact = current_user.contacts.build(contacted_id: params[:contacted_id])
  end
end
