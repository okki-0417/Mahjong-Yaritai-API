class Learnings::QuestionsController < ApplicationController
  def index
    questions = LearningCategory.find(params[:category_id]).questions

    render json: questions, status: :ok
  end

  def show
    question = LearningCategory.find(params[:category_id]).questions.find(params[:id])

    render json: question, status: :ok
  end
end
