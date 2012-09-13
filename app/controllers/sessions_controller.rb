class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
      self.current_user = user
      redirect_to root_path, :notice => "Logged in!"
    else
      flash.now[:error] = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session.clear
    redirect_to root_path, :notice => "Logged out!"
  end
end
