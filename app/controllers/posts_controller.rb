class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update my_posts]

  def index
    @heading = 'MembersOnly! - Coolest stories, from all over the world'
    @posts = Post.order('updated_at DESC')
  end

  def my_posts
    @heading = 'My Stories'
    @posts = Post.where(user: current_user).order('updated_at DESC')
    render :index
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(title: params.dig(:post).dig(:title), body: params.dig(:post).dig(:body), user: current_user)

    if @post.save
      redirect_to post_path(@post)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find_by_id(params[:id])

    if @post.nil?
      flash[:alert] = "Post with id '#{params[:id]}' does not exist."
      return redirect_to root_path
    end

    @comment = Comment.new(post: @post)
  end

  def edit
    @post = Post.find_by_id(params[:id])

    if @post.nil?
      flash[:alert] = "Post with id '#{params[:id]}' does not exist."
      return redirect_to root_path
    end

    if current_user != @post.user
      flash[:alert] = "You can't edit someone else's post!"
      redirect_to root_path
    end
  end

  def update
    @post = Post.find_by_id(params[:id])

    if @post.nil?
      flash[:alert] = "Post with id '#{params[:id]}' does not exist."
      return redirect_to root_path
    end

    if current_user != @post.user
      flash[:alert] = "You can't edit someone else's post!"
      return redirect_to root_path
    end

    if @post.update(title: params[:post][:title], body: params[:post][:body])
      redirect_to post_path(@post)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find_by_id(params[:id])

    if @post.nil?
      flash[:alert] = "Post with id '#{params[:id]}' does not exist."
      return redirect_to root_path
    end

    if current_user == post.user
      post.destroy
      flash[:notice] = 'Post has been deleted.'
      redirect_to root_path
    else
      flash[:alert] = "You can't delete someone else's post!"
      redirect_to root_path
    end
  end
end
