# frozen_string_literal: true

require "rails_helper"

RSpec.describe Authorization, type: :model do
  describe "#validations" do
    let(:authorization) { FactoryBot.build(:authorization, email:) }
    let(:email) { "" }

    subject { authorization }

    context "emailが空の場合" do
      it_behaves_like :invalid
    end

    context "emailが入っている場合" do
      let(:email) { "test@mahjong-yaritai.com" }

      context "emailが既にユーザーに使われていた場合" do
        before { FactoryBot.create(:user, email:) }

        it_behaves_like :invalid
      end

      context "emailが既にユーザーに使われていなかった場合" do
        it_behaves_like :valid
      end
    end
  end

  describe "#callbacks" do
    describe "#generate_token" do
      let(:authorization) { FactoryBot.build(:authorization, email:) }
      let(:email) { "test@mahjong-yaritai.com" }

      subject { authorization.save }

      context "正常に作成された場合" do
        it "tokensが作成されていること" do
          expect(authorization.token).to eq nil
          subject
          expect(authorization.token).not_to eq nil
        end
      end
    end
  end
end
