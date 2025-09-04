class Learnings::CategoriesController < ApplicationController
  def index
    categories = LearningCategory.all

    render json: categories, status: :ok
  end

  def show
    category = LearningCategory.find(params[:id])

    render json: category, status: :ok
  end
end
