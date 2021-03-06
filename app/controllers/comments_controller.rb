# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]

  def index
    @comments = Comment.all
  end

  def edit
    @task = Task.find_by(params[:task_id])
  end

  def new
    @comment = Comment.new
  end

  def create
    result = CreateComment.call(comment_params: comment_params, current_user: current_user)
    if result.success?
      redirect_to task_path(@comment.task_id), notice: 'Comment created successfully'
    else
      redirect_to task_path(comment_params[:task_id]), notice: "#{result.error}"
    end
  end

  def update
    result = UpdateComment.call(
      comment_params: comment_params.merge(id: @comment.id),
      current_user: current_user
    )
    if result.success?
      redirect_to task_path(@comment.task_id), notice: 'Comment updated successfully'
    else
      redirect_to task_path(comment_params[:task_id]), notice: "#{result.error}"
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:task_id, :content)
  end
end
