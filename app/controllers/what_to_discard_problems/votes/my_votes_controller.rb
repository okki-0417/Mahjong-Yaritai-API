# frozen_string_literal: true

class WhatToDiscardProblems::Votes::MyVotesController < ApplicationController
  def show
    return render json: nil, serializer: WhatToDiscardProblem::Vote::MyVoteSerializer,
root: :my_vote, status: :ok unless logged_in?

    my_vote = WhatToDiscardProblem::Vote.find_by(
      what_to_discard_problem_id: params[:what_to_discard_problem_id],
      user_id: current_user&.id,
    )

    render json: my_vote, serializer: WhatToDiscardProblem::Vote::MyVoteSerializer, root: :my_vote,
status: :ok
  end
end
