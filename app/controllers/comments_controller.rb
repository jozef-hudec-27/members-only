class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find_by_id(params[:comment][:post_id])

    if @post.nil?
      flash[:alert] = 'Post does not exist.'
      return redirect_to root_path
    end

    @comment = Comment.new(body: params[:comment][:body], user: current_user, post: @post)
    
    if @comment.save
      redirect_to post_path(@post)
    else
      render 'posts/show', status: :unprocessable_entity
    end
  end

  def destroy
  end
end