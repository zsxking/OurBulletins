class PostsController < ApplicationController
  before_filter :authenticate, :except => [:show, :index]
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @title = "Posts"
    @posts = Post.all.paginate(:page => params[:page])
  end

  def show
    @post = Post.find(params[:id]);
  end

  def new
    @title = 'New Post'
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      flash[:success] = "New Listing Posted."
      redirect_to @post
    else
      @title = "New Post"
      render 'new'
    end
  end

  def edit
    @title = "Edit | #{@post.title}"
  end

  def update
    if @post.update_attributes(params[:post])
      flash[:success] = "Post updated."
      redirect_to @post
    else
      @title = "Edit | #{@post.title}"
      render 'edit'
    end
  end

  private

    def correct_user
      @post = Post.find(params[:id])
      if !current_user?(@post.user)
        flash[:error] = "Invalid user."
        redirect_to @post
      end
    end

end
