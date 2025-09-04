# frozen_string_literal: true

require "rails_helper"

RSpec.describe Auth::VerificationForm, type: :model do
  describe "#validations" do
    subject { described_class.new(token:) }
    let(:token) { "000000" }

    describe "#must_in_expiration" do
      context "auth_requestが期限切れの場合" do
        let(:token) { create(:auth_request, :expired).token }

        it { is_expected.to be_invalid }
      end

      context "auth_requestが期限内の場合" do
        let(:token) { create(:auth_request).token }

        it { is_expected.to be_valid }
      end
    end
  end
end
