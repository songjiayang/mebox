class SessionsController < ApplicationController

  skip_before_action :should_login, only: [:new, :create]

  def new
    @signin = SignIn.new
  end

  def create
    @signin = SignIn.new(sign_in_params)

    if @signin.authenticate!
      sign_in @signin.user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  private

  def sign_in_params
    params
      .require(:signin)
      .permit(
        :name, :password
      )
  end
end
