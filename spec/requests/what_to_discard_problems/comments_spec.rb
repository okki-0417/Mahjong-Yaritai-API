# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WhatToDiscardProblems::Comments", type: :request do
  describe "#index" do
    let(:what_to_discard_problem) { FactoryBot.create(:what_to_discard_problem) }
    let(:what_to_discard_problem_id) { 0 }

    subject { get what_to_discard_problem_comments_url(what_to_discard_problem_id:) }

    context "投稿が存在しない場合" do
      it_behaves_like :response, 404
    end

    context "投稿が存在する場合" do
      let(:what_to_discard_problem_id) { what_to_discard_problem.id }

      context "コメントが存在しない場合" do
        it_behaves_like :response, 200
      end

      context "コメントが存在する場合" do
        let!(:what_to_discard_problem_comment) { FactoryBot.create(:what_to_discard_problem_comment, what_to_discard_problem_id:) }

        it_behaves_like :response, 200
      end
    end
  end


  describe "#create" do
    let(:current_user) { FactoryBot.create(:user) }
    let(:what_to_discard_problem_id) { FactoryBot.create(:what_to_discard_problem).id }

    let(:content) { nil }
    let(:parent_comment_id) { 0 }

    subject { post what_to_discard_problem_comments_url(what_to_discard_problem_id:), params: {
      what_to_discard_problem_comment: {
        parent_comment_id:,
        content:
      }
    }}

    context "未ログインの場合" do
      it_behaves_like :response, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      context "モデルのバリデーションに通らない場合" do
        before { allow_any_instance_of(WhatToDiscardProblem::Comment).to receive(:save).and_return(false) }

        it_behaves_like :response, 422
      end

      context "モデルのバリデーションに通る場合" do
        let(:content) { "a" * 500 }
        let(:parent_comment_id) { FactoryBot.create(:what_to_discard_problem_comment, what_to_discard_problem_id:).id }

        it_behaves_like :response, 201
      end
    end
  end
end
