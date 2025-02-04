# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AuthorizationsController", type: :request do
  let(:token) { "" }

  subject { post authorization_url,
    params: {
      token:,
    }
  }

  context "authorizationが存在しない場合" do
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

      it_behaves_like :response, 204
    end
  end
end
