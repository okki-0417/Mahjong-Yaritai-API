class Learnings::CategoriesController < ApplicationController
  def index
    categories = LearningCategory.all

    render json: categories,
      each_serializer: Learning::CategorySerializer,
      root: :learning_categories,
      status: :ok
  end

  def show
    category = LearningCategory.find(params[:id])

    render json: category,
      serializer: Learning::CategorySerializer,
      root: :learning_category,
      status: :ok
  end
end
