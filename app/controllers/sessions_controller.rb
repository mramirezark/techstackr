class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create ]

  def new
    # Login form
  end

  def create
    user = User.find_by(username: params[:username].downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Welcome back, #{user.username}!"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You have been logged out successfully."
  end
end
