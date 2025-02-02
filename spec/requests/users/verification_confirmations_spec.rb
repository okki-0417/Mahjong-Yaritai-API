# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::VerificationConfirmationsController", type: :request do
  describe "#create" do
    let(:params) { {} }
    let(:session) { {} }
    let(:session_double) { instance_double(ActionDispatch::Request::Session, enabled?: true, loaded?: false) }

    subject { get users_verification_confirmation_url, params: }

    before { allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(session_double) }

    context "params[:token]がない場合" do
      it_behaves_like :response, 422
    end

    context "params[:token]がある場合" do
      let(:params) { { token: "token" } }

      context "session[:token]がない場合" do
        before { allow(session_double).to receive(:[]).with(:token).and_return(nil) }

        it_behaves_like :response, 422
      end

      context "session[:token]がある場合" do
        let(:session_values) { { token: "token" } }
        before { allow(session_double).to receive(:[]).with(:token).and_return("token") }

        context "バリデーションに通らない場合" do
          before { allow_any_instance_of(User::VerificationConfirmationForm).to receive(:valid?).and_return(false) }

          it_behaves_like :response, 422
        end

        context "バリデーションに通る場合" do
          let(:temp_user) { FactoryBot.create(:temp_user) }

          before {
            allow_any_instance_of(User::VerificationConfirmationForm).to receive_messages(
              :valid? => true,
              temp_user:,
            )

            allow(session_double).to receive(:delete)
            allow(session_double).to receive(:[]=).with(:email, temp_user.email)
            allow(session_double).to receive(:[]=).with(:verification_session_expired_at, temp_user.expired_at)
          }

          it_behaves_like :response, 204
        end
      end
    end
  end
end
