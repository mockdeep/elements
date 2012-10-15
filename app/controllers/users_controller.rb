class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      Notifier.signup_email(@user).deliver
      self.current_user = @user
      redirect_to root_path, :notice => "Signed up!"
    else
      flash.now[:error] = 'There was a problem creating your account'
      render "new"
    end
  end
end
