# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WhatToDiscardProblems::Comments", type: :request do
  let(:current_user) { FactoryBot.create(:user) }

  describe "#create" do
    let(:what_to_discard_problem) { FactoryBot.create(:what_to_discard_problem) }
    let(:reply_to_comment) { FactoryBot.create(:what_to_discard_problem_comment, what_to_discard_problem_id: what_to_discard_problem.id) }
    let(:reply_to_comment_id) { reply_to_comment.id }
    let(:content) { "a" * 500 }

    subject { post what_to_discard_problem_comments_url(what_to_discard_problem_id: what_to_discard_problem.id), params: {
      what_to_discard_problem_comment: {
        reply_to_comment_id:,
        content:
      }
    }}

    context "未ログインの場合" do
      it_behaves_like :response, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      context "contentが不正な値の場合" do
        context "空の場合" do
          let(:content) { "" }

          it_behaves_like :response, 422
        end

        context "500文字よりも長い場合" do
          let(:content) { "a" * 501 }

          it_behaves_like :response, 422
        end
      end

      context "contentが正常な値の場合" do
        context "返信先のコメントが存在しない場合" do
          let(:reply_to_comment_id) { nil }

          it_behaves_like :response, 201
        end

        context "返信先のコメントが存在する場合" do
          context "その問題に存在しないコメントidを返信先に指定した場合" do
            let(:reply_to_comment) { FactoryBot.create(:what_to_discard_problem_comment) }
            let(:reply_to_comment_id) { reply_to_comment.id }

            it_behaves_like :response, 422
          end

          context "正常に返信先のコメントを指定した場合" do
            it_behaves_like :response, 201
          end
        end
      end
    end
  end
end
