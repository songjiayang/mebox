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
    if params[:contacted_id] == current_user.name
      render json: { message: "Unable to add yourself to your Contacts"}, status: 400
      return
    end

    contacted_user = User.find_by(name: params[:contacted_id])
    if contacted_user.nil?
      render json: { message: "User not found"}, status: 400
      return
    end

    contact = current_user.contacts.build(contacted_id: params[:contacted_id])
    contact.save
    if contact.errors.any?
      render json: { message: contact.errors.to_a.first }, status: 400
      return
    end

    render json: contact
  end

  def update
    contact = current_user.contacts.find_by(id: params[:id])
    if contact.nil?
      render json: { message: "Contact not found" }, status: 404
      return
    end

    contact.update_attributes(new_message: 0)
    render json: {}
  end

  def destroy
    contact = current_user.contacts.find_by(id: params[:id])
    if contact.nil?
      render json: { message: "Contact not found" }, status: 404
      return
    end

    unless contact.destroy
      render json: { message: contact.errors.to_a.first }, status: 500
      return
    end

    render json: { message: "Contact deleted successful" }
  end
end
