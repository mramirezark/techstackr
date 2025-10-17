class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [ :edit, :update, :destroy, :modal_edit, :modal_delete ]

  def index
    @users = User.all.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def modal_new
    @user = User.new

    respond_to do |format|
      format.html { render partial: "modal_new", layout: false }
    end
  end

  def modal_edit
    respond_to do |format|
      format.html { render partial: "modal_edit", layout: false }
    end
  end

  def modal_delete
    respond_to do |format|
      format.html { render partial: "modal_delete", layout: false }
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path, notice: "User #{@user.username} was successfully created." }
        format.json { render json: { success: true, message: "User #{@user.username} was successfully created.", redirect_url: admin_users_path }, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    # Don't require password if not changing it
    if user_params[:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.update(user_params.except(:password, :password_confirmation).compact)
        # Update password separately if provided
        if user_params[:password].present?
          @user.update(password: user_params[:password], password_confirmation: user_params[:password_confirmation])
        end
        format.html { redirect_to admin_users_path, notice: "User #{@user.username} was successfully updated." }
        format.json { render json: { success: true, message: "User #{@user.username} was successfully updated.", redirect_url: admin_users_path }, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @user == current_user
      respond_to do |format|
        format.html { redirect_to admin_users_path, alert: "You cannot delete yourself!" }
        format.json { render json: { success: false, message: "You cannot delete yourself!" }, status: :unprocessable_entity }
      end
      return
    end

    username = @user.username
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: "User #{username} was successfully deleted." }
      format.json { render json: { success: true, message: "User #{username} was successfully deleted.", redirect_url: admin_users_path }, status: :ok }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :role)
  end
end
