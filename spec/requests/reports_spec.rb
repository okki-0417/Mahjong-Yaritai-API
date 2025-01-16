# frozen_string_literal: true

require "rails_helper"

RSpec.describe "reports", type: :request do
  describe "index" do
    subject { get reports_url }

    it "200を返すこと" do
      subject
      expect(response).to have_http_status(200)
    end
  end

  describe "new" do
    subject { get new_report_url }
    it "200を返すこと" do
      subject
      expect(response).to have_http_status(200)
    end
  end

  describe "create" do
    subject { post reports_url, params: }

    context "正しい値の場合" do
      let(:params) { {
        content_name: "okazu",
        reference: "okazu.com",
        description: "This is an example report"
      } }

      it "作成されること" do
        expect { subject }.to change(Report, :count).by(1)
        expect(response).to have_http_status(201)
      end
    end
  end
end
