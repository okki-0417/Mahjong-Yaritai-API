# frozen_string_literal: true

class Me::Withdrawals::SummariesController < Me::BaseController
  def show
    render json: current_user.withdrawal_summary,
           serializer: WithdrawalSummarySerializer,
           root: :withdrawal_summary,
           status: :ok
  end
end
