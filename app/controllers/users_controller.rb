class UsersController < ApplicationController
  before_filter :signed_in_user,  only: [:edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,    only: [:edit, :update]
  before_filter :deny_access_to_logged_in,   only: [:new, :create]

  def show
    @user = User.find(params[:id])
    @story_snippets = @user.story_snippets.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome back #{@user.name}"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      # TODO send email if we've updated the email
      flash[:success] = "Profile sucessfully updated"
      sign_in @user
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    # TODO implement user delete?
  end

  def following
    @user = User.find(params[:id])
    @title = "Following"
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @title = "Followers"
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def stories
    @user = User.find(params[:id])
    @stories = @user.stories.paginate(page: params[:page])
  end

  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
