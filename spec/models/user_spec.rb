# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "#withdrawal_summary" do
    subject { user.withdrawal_summary }
    let(:user) { create(:user) }

    context "何切る問題を作成していた場合" do
      before do
        create_list(:what_to_discard_problem, 3, user:)
      end

      it "何切る問題の数を返す" do
        expect(subject[:what_to_discard_problems_count]).to eq 3
      end
    end
  end
end
