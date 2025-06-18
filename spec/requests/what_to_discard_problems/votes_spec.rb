# frozen_string_literal: true

require "rails_helper"

describe "WhatToDiscardProblems::VotesController", type: :request do
  describe "#create" do
    subject { post what_to_discard_problem_votes_url(what_to_discard_problem_id:), params: {
      what_to_discard_problem_vote: {
        tile_id:,
      },
    } }
    let(:what_to_discard_problem_id) { create(:what_to_discard_problem).id }
    let(:tile_id) { create(:tile).id }
    let(:current_user) { create(:user) }

    context "未ログインの場合" do
      it_behaves_like :response, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      context "バリデーションに通らない場合" do
        before { allow_any_instance_of(WhatToDiscardProblem::Vote).to receive(:save).and_return(false) }

        it_behaves_like :response, 422
      end

      context "バリデーションに通る場合" do
        it_behaves_like :response, 201
      end
    end
  end

  describe "#destroy" do
    subject {
 delete what_to_discard_problem_vote_url(what_to_discard_problem_id: what_to_discard_problem.id, id: vote.id) }

    let(:what_to_discard_problem) { create(:what_to_discard_problem) }
    let(:vote) { create(:what_to_discard_problem_vote, what_to_discard_problem:, user: current_user) }
    let(:current_user) { create(:user) }

    context "未ログインの場合" do
      it_behaves_like :response, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      context "削除に失敗した場合" do
        before { allow_any_instance_of(WhatToDiscardProblem::Vote).to receive(:destroy).and_return(false) }

        it_behaves_like :response, 422
      end

      context "削除に成功した場合" do
        it_behaves_like :response, 204
      end
    end
  end
end
