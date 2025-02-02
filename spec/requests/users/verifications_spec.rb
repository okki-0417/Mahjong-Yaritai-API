# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::VerificationsController", type: :request do
  describe "#create" do
    let(:email) { "test@mahjong-yaritai.com" }

    subject { post users_verification_url,
      params: {
        user_verification: {
          email:
        }
      }
    }

    context "emailのバリデーションが通らない場合" do
      before { allow_any_instance_of(User::VerificationForm).to receive(:valid?).and_return(false) }

      it_behaves_like :response, 422
    end

    context "emailのバリデーションが通る場合" do
      before { allow_any_instance_of(User::VerificationForm).to receive(:valid?).and_return(true) }

      context "TempUserのバリデーションが通らない場合" do
        before { allow_any_instance_of(TempUser).to receive(:valid?).and_return(false) }

        it_behaves_like :response, 422
      end

      context "TempUserのバリデーションが通る場合" do
        before { allow_any_instance_of(TempUser).to receive(:valid?).and_return(true) }

        it_behaves_like :response, 204

        it "認証メールが送信されること" do
          expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end
    end
  end
end
