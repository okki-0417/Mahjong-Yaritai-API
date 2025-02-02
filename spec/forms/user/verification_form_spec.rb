# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::VerificationForm, type: :model do
  describe "validations" do
    describe "check_email_uniqueness" do
      let(:email) { "test@mahjong-yaritai.com" }
      let(:user_verification_form) { described_class.new(email:) }

      subject { user_verification_form }

      context "既に存在するemailの場合" do
        before { FactoryBot.create(:user, email:) }

        it_behaves_like :invalid
        it_behaves_like :error_added, :email, :taken
      end

      context "存在しないemailの場合" do
        it_behaves_like :valid
      end
    end
  end
end
