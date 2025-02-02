# frozen_string_literal: true

require "rails_helper"

RSpec.describe WhatToDiscardProblemComment, type: :model do
  describe "validations" do
    let(:user) { FactoryBot.create(:user) }
    let(:what_to_discard_problem) { FactoryBot.create(:what_to_discard_problem) }
    let(:reply_to_comment) { FactoryBot.create(:what_to_discard_problem_comment, what_to_discard_problem:) }

    let(:user_id) { user.id }
    let(:what_to_discard_problem_id) { what_to_discard_problem.id }
    let(:reply_to_comment_id) { reply_to_comment.id }

    let(:content) { "a" * 500 }

    subject {
      described_class.new(
        what_to_discard_problem_id:,
        user_id:,
        reply_to_comment_id:,
        content:,
      )
    }

    context "不正な値が存在する場合" do
      context "contentが不正な場合" do
        context "空の場合" do
          let(:content) { "" }

          it "バリデーションが通らないこと" do
            expect(subject).to be_invalid
            expect(subject.errors).to be_added(:content, :blank)
          end
        end

        context "500文字よりも長い場合" do
          let(:content) { "a" * 501 }

          it "バリデーションが通らないこと" do
            expect(subject).to be_invalid
            expect(subject.errors).to be_added(:content, :too_long, count: 500)
          end
        end
      end

      context "reply_to_comment_idが不正な場合" do
        context "返信先のコメントが同一問題内のコメントでない場合" do
          let(:reply_to_comment) { FactoryBot.create(:what_to_discard_problem_comment) }
          let(:reply_to_comment_id) { reply_to_comment.id }

          it "バリデーションが通らないこと" do
            expect(subject).to be_invalid
            expect(subject.errors).to be_added(:reply_to_comment_id, :invalid)
          end
        end
      end
    end

    context "正常な値の場合" do
      it "バリデーションが通ること" do
        expect(subject).to be_valid
      end

      context "reply_to_comment_idが空の場合" do
        let(:reply_to_comment_id) { nil }

        it "バリデーションが通ること" do
          expect(subject).to be_valid
        end
      end
    end
  end
end
