class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find_by_id(params.dig(:comment).dig(:post_id))

    if @post.nil?
      flash[:alert] = 'Post does not exist.'
      return redirect_to root_path
    end

    @comment = Comment.new(body: params.dig(:comment).dig(:body), user: current_user, post: @post)
    
    if @comment.save
      redirect_to post_path(@post)
    else
      render 'posts/show', status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find_by_id(params[:id])

    if comment.nil?
      flash[:alert] = "Comment with id '#{params[:id]}' does not exist."
      return redirect_to root_path
    end

    if current_user == comment.user
      comment.destroy
      flash[:notice] = 'Comment has been deleted.'
      redirect_to post_path(comment.post)
    else
      flash[:alert] = "You can't delete someone else's comment!"
      redirect_to post_path(comment.post)
    end
  end
end