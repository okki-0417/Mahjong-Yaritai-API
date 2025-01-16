# frozen_string_literal: true

class ForumThreadsController < ApplicationController
  before_action :restrict_to_logged_in_user, only: [ :create, :edit, :update, :destroy ]
  protect_from_forgery with: :exception, only: [ :create ]

  def index
    @forum_threads = ForumThread.all
    render json: { forum_threads: @forum_threads }, status: :ok
  end

  def create
    @forum_thread = current_user.created_threads.new(thread_params)

    if @forum_thread.save
      render json: { forum_thread: @forum_thread }, status: :created
    else
      render json: { errors: @forum_thread.errors.full_messages.map { |message| { message: } } }, status: :unprocessable_entity
    end
  end

  def show
    @forum_thread = ForumThread.find(params[:id])

    if @forum_thread.present?
      render json: { forum_thread: @forum_thread }, status: :ok
    else
      render json: { errors: [ { message: "Resource not found" } ] }, status: :not_found
    end
  end

  def edit
    @forum_thread = current_user.created_threads.find_by(id: params[:id])

    if @forum_thread.present?
      render json: { forum_thread: @forum_thread }, status: :ok
    else
      render json: { errors: [ { message: "Resource not found" } ] }, status: :not_found
    end
  end

  def update
    @forum_thread = current_user.created_threads.find_by(id: params[:id])

    return render json: { errors: [ { message: "Resource not found" } ] }, status: :not_found if @forum_thread.present?

    if @forum_thread.update(thread_params)
      render json: { forum_thread: @forum_thread }, status: :created
    else
      render json: { errors: @forum_thread.errors_full_messages.map((message) => { message: }) }, status: :unprocessable_entity
    end
  end

  def destroy
    @forum_thread = current_user.created_threads.find_by(id: params[:id])

    return render json: { errors: [ { message: "Resource not found" } ] }, status: :not_found if @forum_thread.present?

    @forum.destroy

    render json: { message: "Forum thread deleted successfully" }, status: :no_content
  end

  private

  def thread_params
    params.require(:forum_thread).permit(:topic)
  end
end
