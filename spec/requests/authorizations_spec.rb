# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthorizationsController, type: :request do
  describe "#create" do
    subject do
      post authorization_url,
        params: {
          authorization: {
            token:
          },
        }
    end

    let(:token) { nil }

    context "authorizationが存在しない場合" do
      before { allow(Authorization).to receive(:find_by).and_return(false) }

      it_behaves_like :response, 422
    end

    context "authorizationが存在する場合" do
      let(:authorization) { FactoryBot.create(:authorization) }
      let(:token) { authorization.token }

      context "有効期限切れの場合" do
        before { allow_any_instance_of(Authorization).to receive(:expired?).and_return(true) }

        it_behaves_like :response, 422
      end

      context "有効期限内の場合" do
        before { allow_any_instance_of(Authorization).to receive(:expired?).and_return(false) }

        it_behaves_like :response, 200
      end
    end
  end

  describe "#show" do
    subject { get authorization_url }

    context "権限が付与されていない場合" do
      it_behaves_like :response, 200
    end

    context "権限が付与されている場合" do
      it_behaves_like :response, 200
    end
  end
end
