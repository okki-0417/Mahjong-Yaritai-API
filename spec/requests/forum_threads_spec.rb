# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ForumThreadsController", type: :request do
  let(:current_user) { FactoryBot.create(:user) }

  describe "#index" do
    subject { get forum_threads_url }

    it "未ログインでもレスポンス200を返すこと" do
      subject
      expect(response).to have_http_status(200)
    end
  end

  describe "#create" do
    subject { post forum_threads_url, params: {
      forum_thread: {
        topic:
      }
    } }

    context "未ログインの場合" do
      let(:topic) { "topic_name" }

      it "401を返すこと" do
        expect { subject }.not_to change { ForumThread.count }
        expect(response).to have_http_status(401)
      end
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      context "正しい値の場合" do
        let(:topic) { "topic_name" }

        it "201を返すこと" do
          expect { subject }.to change { ForumThread.count }.by(1)
          expect(response).to have_http_status(201)
        end
      end

      context "不正な値の場合" do
        let(:topic) { "" }

        it "422を返すこと" do
          expect { subject }.not_to change { ForumThread.count }
          expect(response).to have_http_status(422)
        end
      end
    end

    describe "#show" do
      subject { get forum_thread_url(forum_thread_id) }

      context "正しいidの場合" do
        let(:forum_thread_id) { FactoryBot.create(:forum_thread).id }


        it "未ログインでもレスポンス200を返すこと" do
          subject
          expect(response).to have_http_status(200)
        end
      end

      context "存在しないidの場合" do
        let(:forum_thread_id) { 000 }

        it "404を返すこと" do
          subject
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
