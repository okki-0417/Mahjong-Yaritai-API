# frozen_string_literal: true

class SidekiqsController < ApplicationController
  def show
    TestWorker.perform_async("こんにちは")
    head :ok
  end
end
