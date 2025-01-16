# frozen_string_literal: true

class ReportsController < ApplicationController
  def index
    reports = Report.all.limit(100) # TODO:いつか直す
    render json: { reports: }, status: :ok
  end

  def new
    head :ok
  end

  def create
    report = current_user.reports.new(report_params)
    if report.save
      render json: { report: report }, status: :created
    else
      render json: { errors: report.errors.full_messages.map((message) => { message: }) }
    end
  end

  def show
    @report = current_user.reports.find(params[:id])
  end

  def edit
  end

  def destroy
  end

  private

  def report_params
    params.require(:report).permit(:content_name, :reference, :description)
  end
end
