# frozen_string_literal: true

require "rails_helper"

RSpec.describe Authorization, type: :model do
  describe "#validations" do
    subject { authorization.valid? }

    describe "#check_email_uniqueness" do
      let(:authorization) { described_class.new(email:) }
      let(:email) { "test@mahjong-yaritai.com" }

      context "emailが既にユーザーに使われていた場合" do
        before { create(:user, email:) }

        it "バリデーションに通らず、エラーが追加されていること" do
          is_expected.to eq false
          expect(authorization.errors).to be_added(:email, :taken)
        end
      end
    end
  end

  describe "#callbacks" do
    describe "#generate_token" do
      let(:authorization) { described_class.new(email:) }
      let(:email) { "test@mahjong-yaritai.com" }

      subject { authorization.save }

      context "正常に作成された場合" do
        it "tokensが作成されていること" do
          expect(authorization.token).to eq nil
          subject
          expect(authorization.token).to be_present
        end
      end
    end
  end
end
