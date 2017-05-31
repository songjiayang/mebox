class UsersController < ApplicationController
  skip_before_action :should_login
  before_action :should_sign_out

  def new
    @user = User.new
  end

  def create
    @user = User.new new_params
    if @user.save
      sign_in(@user.id)
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def new_params
    params
      .require(:user)
      .permit(
        :name, :password
      )
  end
end
