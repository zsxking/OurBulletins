class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update, :deactivate]
  before_filter :admin_user, :only => [:ban]
  before_filter :not_on_admin_user, :only => [:ban]

  def index
    @title = "Users"
    @users = User.all.paginate(:page => params[:page])
  end

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
      login(@user)
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
    #@user = User.new(params[:id])
    @title = "Edit user"
  end

  def update
    #@user = User.new(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def deactivate
    if @user.update_attribute(:status, UserStatus::DEACTIVATED)
      logout
      flash[:success] = "Your #{app_name} account has been deactivated.
                         You can reactivate at any time by logging into #{app_name}
                         using your old login email and password."
      redirect_to root_path
    else
      flash[:error] = 'Deactivation failed. Please try again later.'
      redirect_to @user
    end

  end

  def ban
    if @user.update_attribute(:status, UserStatus::BANNED)
      flash[:success] = "#{@user.name} has been banned."
    else
      flash[:error] = 'Ban action failed. Please try again later.'
    end
    redirect_to users_path
  end

  private

    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        flash[:error] = "Invalid user."
        redirect_to root_path
      end
    end

    def admin_user
      if !current_user.admin?
        flash[:error] = 'Invalid action.'
        redirect_to root_path
      end
    end

    def not_on_admin_user
      @user = User.find(params[:id])
      if  @user.nil?
        flash.now[:error] = 'User Not Found.'
        redirect_to users_path
      elsif @user.admin?
        flash.now[:error] = 'Invalid action.'
        redirect_to @user
      end
    end

end
