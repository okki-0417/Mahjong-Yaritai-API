# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }
  let(:session_data) { { user_id: user.id }.to_json }
  let(:cookies_data) { { user_id: user.id, remember_token: user.remember_token }.to_json }

  before {
    module SessionHelper
      def reset_session; end
    end
    helper.extend(SessionHelper)
  }

  describe "#login" do
    let(:user) { FactoryBot.create(:user) }
    let(:session_key) { :hello_session }

    subject { helper.login(user )}

    it "sessionにキーが入ること" do
      expect { subject }.to change { session[:session_key] }
    end
  end

  describe "#remember" do
    let(:user) { FactoryBot.create(:user) }

    subject { helper.remember(user) }

    it "cookiesにキーが入ること" do
      expect { subject }.to change { cookies.signed[:cookies_key] }
    end
  end

  describe "#current_user" do
    subject { helper.current_user }

    context "sessionが空の場合" do
      before { session[:session_key] = nil }

      context "cookiesが空の場合" do
        before { cookies.signed[:cookies_key] = nil }

        it "nilを返すこと" do
          expect(subject).to be_nil
        end
      end

      context "cookiesが入っている場合" do
        context "無効な値の場合" do
          before {
            cookies.signed[:cookies_key] = "xxx"
            allow($redis).to receive(:get).and_return(nil)
          }

          it "nilを返すこと" do
            expect(subject).to be_nil
          end
        end

        context "有効な値の場合" do
          before {
            cookies.signed[:cookies_key] = "hello_cookies"
            allow($redis).to receive(:get).and_return(cookies_data)
            allow_any_instance_of(User).to receive(:authenticated?).and_return(true)
          }

          it "ユーザーを返すこと" do
            expect(subject).to eq user
          end
        end
      end
    end

    context "sessionが入っている場合" do
      context "無効な値の場合" do
        before {
          session[:session_key] = "xxx"
          allow($redis).to receive(:get).and_return(nil)
        }

        it "nilを返すこと" do
          expect(subject).to be_nil
        end
      end

      context "有効な値の場合" do
        before {
          session[:session_key] = "hello_session"
          allow($redis).to receive(:get).and_return(session_data)
        }
        it "ユーザーを返すこと" do
          expect(subject).to eq user
        end
      end
    end
  end

  describe "#forget" do
    let(:user) { FactoryBot.create(:user) }

    before { cookies[:cookies_key] = "hello_session" }

    subject { helper.forget(user) }

    it "cookiesが削除されること" do
      subject
      expect(cookies[:session_key]).to be_nil
    end
  end
end
