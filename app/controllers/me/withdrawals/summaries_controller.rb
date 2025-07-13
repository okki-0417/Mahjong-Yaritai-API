# frozen_string_literal: true

class Me::Withdrawals::SummariesController < Me::BaseController
  def show
    withdrawal_summary = {
      what_to_discard_problems_count: current_user.created_what_to_discard_problems.count,
    }

    render json: withdrawal_summary,
           serializer: WithdrawalSummarySerializer,
           root: :withdrawal_summary,
           status: :ok
  end
end
