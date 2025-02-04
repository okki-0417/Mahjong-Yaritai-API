# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AuthorizationSessionsController", type: :request do
  describe "#create" do
    let(:email) { "test@mahjong-yaritai.com" }

    subject { post authorization_session_path,
      params: {
        authorization_session: {
          email:,
        }
      }
    }

    context "バリデーションに失敗した場合" do
      let(:email) { nil }

      it_behaves_like :response, 422
    end

    context "バリデーションに成功した場合" do
      it_behaves_like :response, 201

      it "メールが送信されること" do
        expect { subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
