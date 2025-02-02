# frozen_string_literal: true

require "rails_helper"

RSpec.describe TempUser, type: :model do
  let(:temp_user) { FactoryBot.build(:temp_user, email:, token:, expired_at:) }
  let(:email) { "" }
  let(:token) { "" }
  let(:expired_at) { "" }

  subject { temp_user }

  describe "#validations" do
    context "emailが空の場合" do
      it_behaves_like :invalid
    end

    context "emailが入っている場合" do
      let(:email) { "test@mahjong-yaritai.com" }

      context "tokenが空の場合" do
        it_behaves_like :invalid
      end

      context "tokenが入っている場合" do
        let(:token) { SecureRandom.urlsafe_base64(64) }

        context "expired_atが空の場合" do
          it_behaves_like :invalid
        end

        context "expired_atが入っている場合" do
          let(:expired_at) { Time.current + 90.minutes }

          it_behaves_like :valid
        end
      end
    end
  end
end
