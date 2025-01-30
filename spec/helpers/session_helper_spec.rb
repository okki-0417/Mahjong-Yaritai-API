# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }
  let(:session_data) { { user_id: user.id }.to_json }
  let(:cookies_data) { { user_id: user.id, remember_token: user.remember_token }.to_json }

  describe "current_user" do
    before {
      module SessionHelper
        def reset_session; end
      end
      helper.extend(SessionHelper)
    }

    before { allow(helper).to receive(:reset_session).and_return(nil) }

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
end
