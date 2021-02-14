class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path
    end
  end
  
  def update
    if current_user.update(user_params)
      redirect_to user_path(current_user)
    else
      redirect_to edit_user_path(current_user)
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to user_url
  end
  
  private
    def user_params
      params.fetch(:user, {}).permit(:email, :name, :username, :gender, :phone, :profile)
    end
end
