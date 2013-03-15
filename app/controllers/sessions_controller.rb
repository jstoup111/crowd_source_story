class SessionsController < ApplicationController
  before_filter :deny_access_to_logged_in,   only: [:new, :create]

  def new
  end

  def create
    user = !User.find_by_email(params[:session][:email].downcase).nil? ? User.find_by_email(params[:session][:email].downcase) : User.find_by_username(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_url
    else
      flash.now[:error] = 'Invalid username/email and password combination.'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
