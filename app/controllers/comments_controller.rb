class CommentsController < ApplicationController
  def create
    comment = Comment.create(comment_params)
    if @comment.save!
      redirect_to item_path
    else
      flash[:notice] = "コメントが入力できませんでした"
    end
  end


    private
    def comment_params
      params.require(:comment).permit(:text).merge(user_id: current_user.id, item_id: params[:item_id])
    end
end