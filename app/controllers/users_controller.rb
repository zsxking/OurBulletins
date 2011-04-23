class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @title = 'Sign Up'
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in(@user)
      flash[:success] = "Welcome to Our Bulletins!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ''
      @user.password_confirmation = ''
      render 'new'
    end
  end

  def edit
    # Not necessary because correct_user method has set it already.
    #@user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        flash[:notice] = "You are not able to edit this."
        redirect_to @user
      end
    end

end
