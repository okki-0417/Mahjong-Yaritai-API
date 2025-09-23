# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Queries::WhatToDiscardProblem", type: :request do
  let(:query) do
    <<~GQL
      query($id: ID!) {
        whatToDiscardProblem(id: $id) {
          id
          round
          turn
          wind
          points
          description
          votesCount
          commentsCount
          likesCount
          user {
            id
            name
            avatarUrl
          }
          dora {
            id
            suit
            ordinalNumberInSuit
          }
          hand1 { id suit ordinalNumberInSuit }
          hand2 { id suit ordinalNumberInSuit }
          hand3 { id suit ordinalNumberInSuit }
          hand4 { id suit ordinalNumberInSuit }
          hand5 { id suit ordinalNumberInSuit }
          hand6 { id suit ordinalNumberInSuit }
          hand7 { id suit ordinalNumberInSuit }
          hand8 { id suit ordinalNumberInSuit }
          hand9 { id suit ordinalNumberInSuit }
          hand10 { id suit ordinalNumberInSuit }
          hand11 { id suit ordinalNumberInSuit }
          hand12 { id suit ordinalNumberInSuit }
          hand13 { id suit ordinalNumberInSuit }
          tsumo { id suit ordinalNumberInSuit }
          createdAt
          updatedAt
        }
      }
    GQL
  end

  def execute_query(variables:)
    post "/graphql",
      params: { query: query, variables: variables },
      as: :json
  end

  describe "whatToDiscardProblem" do
    let!(:problem) { create(:what_to_discard_problem) }

    context "when problem exists" do
      it "returns problem with all tile information" do
        execute_query(variables: { id: problem.id })

        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data][:whatToDiscardProblem]

        expect(response).to have_http_status(:ok)
        expect(data[:id]).to eq(problem.id.to_s)
        expect(data[:round]).to eq(problem.round)
        expect(data[:votesCount]).to eq(0)
        expect(data[:commentsCount]).to eq(0)
        expect(data[:likesCount]).to eq(0)

        expect(data[:dora][:id]).to eq(problem.dora_id.to_s)
        expect(data[:hand1][:id]).to eq(problem.hand1_id.to_s)
        expect(data[:tsumo][:id]).to eq(problem.tsumo_id.to_s)
      end

      it "includes user information" do
        execute_query(variables: { id: problem.id })

        json = JSON.parse(response.body, symbolize_names: true)
        user = json[:data][:whatToDiscardProblem][:user]

        expect(user[:id]).to eq(problem.user.id.to_s)
        expect(user[:name]).to eq(problem.user.name)
      end
    end

    context "with votes, comments, and likes" do
      let!(:votes) { create_list(:what_to_discard_problem_vote, 3, what_to_discard_problem: problem) }
      let!(:comments) { create_list(:comment, 2, commentable: problem) }
      let!(:likes) { create_list(:like, 5, likable: problem) }

      it "returns correct counts" do
        execute_query(variables: { id: problem.id })

        json = JSON.parse(response.body, symbolize_names: true)
        data = json[:data][:whatToDiscardProblem]

        expect(data[:votesCount]).to eq(3)
        expect(data[:commentsCount]).to eq(2)
        expect(data[:likesCount]).to eq(5)
      end
    end

    context "when problem does not exist" do
      it "returns null" do
        execute_query(variables: { id: "999999" })

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:whatToDiscardProblem]).to be_nil
      end
    end
  end
end
