# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WhatToDiscardProblems::Like", type: :request do
  describe "#create" do
    let(:current_user) { FactoryBot.create(:user) }
    let(:what_to_discard_problem_id) { FactoryBot.create(:what_to_discard_problem).id }

    subject { post what_to_discard_problem_likes_url(what_to_discard_problem_id:) }

    context "未ログインの場合" do
      it_behaves_like :response, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      context "モデルのバリデーションに通らない場合" do
        before { allow_any_instance_of(WhatToDiscardProblem::Like).to receive(:save).and_return(false)}

        it_behaves_like :response, 422
      end

      context "モデルのバリデーションに通る場合" do
        it_behaves_like :response, 201
      end
    end
  end

  describe "#destroy" do
    let(:current_user) { FactoryBot.create(:user) }
    let(:what_to_discard_problem) { FactoryBot.create(:what_to_discard_problem) }
    let(:what_to_discard_problem_id) { what_to_discard_problem.id }
    let(:id) { FactoryBot.create(:what_to_discard_problem_like, what_to_discard_problem:, user: current_user).id }

    subject { delete what_to_discard_problem_like_url(what_to_discard_problem_id:, id:) }

    context "未ログインの場合" do
      it_behaves_like :response, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      it_behaves_like :response, 204
    end
  end
end
