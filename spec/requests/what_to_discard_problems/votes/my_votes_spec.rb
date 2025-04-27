# frozen_string_literal: true

require "rails_helper"

RSpec.describe WhatToDiscardProblems::Votes::MyVotesController, type: :request do
  describe "#show" do
    subject { get what_to_discard_problem_votes_my_vote_url(what_to_discard_problem_id:) }
    let(:what_to_discard_problem_id) { create(:what_to_discard_problem).id }

    it_behaves_like :response, 200
  end
end
