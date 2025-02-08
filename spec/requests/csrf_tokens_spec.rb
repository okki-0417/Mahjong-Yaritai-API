# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CsrfTokensController", type: :request do
  let(:current_user) { FactoryBot.create(:user) }

  describe "#show" do
    subject { get csrf_token_url }

    it_behaves_like :response, 200
  end
end
