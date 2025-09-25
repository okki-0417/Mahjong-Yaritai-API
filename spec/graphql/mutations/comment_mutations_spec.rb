# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Comment Mutations", type: :request do
  let(:user) { create(:user) }
  let(:problem) { create(:what_to_discard_problem) }

  def execute_mutation(mutation, variables, current_user: nil)
    if current_user
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(current_user)
    else
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(nil)
    end

    post "/graphql", params: { query: mutation, variables: variables }, as: :json
  end

  describe "createComment" do
    let(:mutation) do
      <<~GQL
        mutation($whatToDiscardProblemId: ID!, $content: String!) {
          createComment(input: {
            whatToDiscardProblemId: $whatToDiscardProblemId
            content: $content
          }) {
            comment {
              id
              content
              userId
            }
            errors
          }
        }
      GQL
    end

    it "creates a comment" do
      execute_mutation(
        mutation,
        { whatToDiscardProblemId: problem.id.to_s, content: "Test comment" },
        current_user: user
      )
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:createComment][:comment][:content]).to eq("Test comment")
      expect(json[:data][:createComment][:comment][:userId]).to eq(user.id.to_s)
    end
  end

  describe "deleteComment" do
    let(:mutation) do
      <<~GQL
        mutation($commentId: ID!) {
          deleteComment(input: { commentId: $commentId }) {
            success
            errors
          }
        }
      GQL
    end

    it "deletes a comment" do
      comment = create(:comment, user: user, commentable: problem)
      execute_mutation(mutation, { commentId: comment.id.to_s }, current_user: user)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:deleteComment][:success]).to eq(true)
    end
  end
end