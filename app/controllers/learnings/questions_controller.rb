class Learnings::QuestionsController < ApplicationController
  def index
    questions = LearningCategory.find(params[:category_id]).questions

    render json: questions,
      each_serializer: Learning::QuestionSerializer,
      root: :learning_questions,
      status: :ok
  end

  def show
    question = LearningCategory.find(params[:category_id]).questions.find(params[:id])

    render json: question,
      serializer: Learning::QuestionSerializer,
      root: :learning_question,
      status: :ok
  end
end
