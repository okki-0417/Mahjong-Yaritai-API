# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Comment Mutations", type: :request do
  include GraphqlHelper

  describe "createWhatToDiscardProblemComment" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:variables) { { whatToDiscardProblemId: problem.id.to_s, content: "Test comment" } }
    let(:problem) { create(:what_to_discard_problem) }
    let(:mutation) do
      <<~GQL
        mutation($whatToDiscardProblemId: ID!, $content: String!, $parentCommentId: ID) {
          createWhatToDiscardProblemComment(input: {
            whatToDiscardProblemId: $whatToDiscardProblemId
            content: $content
            parentCommentId: $parentCommentId
          }) {
            comment {
              id
              content
              userId
            }
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:createWhatToDiscardProblemComment]).to be_nil
        expect(json[:errors].any?).to be true
      end

      context "ログインしている時" do
        let(:current_user) { create(:user) }

        context "saveが失敗する場合" do
          before do
            errors = double(full_messages: [ "バリデーションエラー" ])
            comment = instance_double(Comment, save: false, errors:)
            allow(current_user.created_comments).to receive(:new).and_return(comment)
          end

          it "バリデーションエラーが返ること" do
            json = subject

            expect(json[:data][:createWhatToDiscardProblemComment]).to be_nil
            expect(json[:errors].any?).to be true
          end
        end

        context "saveが成功する場合" do
          it "コメントが作成できること" do
            json = subject

            expect(json[:data][:createWhatToDiscardProblemComment]).to be_present
          end
        end
      end
    end
  end

  describe "deleteWhatToDiscardProblemComment" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem) }
    let(:comment) { create(:comment, user: current_user, commentable: problem) }
    let(:variables) { { commentId: comment.id.to_s } }
    let(:mutation) do
      <<~GQL
        mutation($commentId: ID!) {
          deleteWhatToDiscardProblemComment(input: { commentId: $commentId }) {
            id
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }
      let(:comment) { create(:comment, commentable: problem) }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:deleteWhatToDiscardProblemComment]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "削除が成功する場合" do
      it "コメントが削除できること" do
        json = subject

        expect(json[:data][:deleteWhatToDiscardProblemComment]).to be_present
      end
    end
  end
end
