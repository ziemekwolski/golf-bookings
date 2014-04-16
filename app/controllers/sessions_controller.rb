class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(session_params[:email], session_params[:password])
    if user
      redirect_back_or_to clubs_url, :notice => "Logged in!"
    else
      flash.now.alert = "Email or password was invalid"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out!"
  end

private
  def session_params
    params.require(:session).permit(:email, :password)
  end

end
