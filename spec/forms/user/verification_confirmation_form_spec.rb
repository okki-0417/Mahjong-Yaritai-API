# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::VerificationConfirmationForm, type: :model do
  describe "validations" do
    let(:user_verification_form) { described_class.new(params_token:, session_token:) }
    let(:params_token) { "" }
    let(:session_token) { "" }

    subject { user_verification_form }

    context "params_tokenが存在しない場合" do
      it_behaves_like :invalid
      it_behaves_like :error_added, :params_token, :blank
    end

    context "params_tokenが存在する場合" do
      let(:params_token) { "token" }

      context "session_tokenが存在しない場合" do
        it_behaves_like :invalid
        it_behaves_like :error_added, :session_token, :blank
      end

      context "session_tokenが存在する場合" do
        context "#check_confirmation_token_match" do
          context "params_tokenとsession_tokenが一致しない場合" do
            let(:session_token) { "invalid_token" }

            it_behaves_like :invalid
            it_behaves_like :error_added, :params_token, :confirmation_token_mismatch
          end

          context "params_tokenとsession_tokenが一致する場合" do
            let(:session_token) { "token" }

            context "#check_temp_user_existence" do
              context "temp_userが見つからない場合" do
                it_behaves_like :invalid
                it_behaves_like :error_added, :session_token, :temp_user_not_found
              end

              context "temp_userが見つかる場合" do
                let!(:temp_user) { FactoryBot.create(:temp_user, token: session_token) }

                it_behaves_like :valid
              end
            end
          end
        end
      end
    end
  end
end
