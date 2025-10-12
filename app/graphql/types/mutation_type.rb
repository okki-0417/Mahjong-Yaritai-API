# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Auth
    field :request_auth, mutation: Mutations::Auth::RequestAuth
    field :verify_auth, mutation: Mutations::Auth::VerifyAuth
    field :logout, mutation: Mutations::Auth::Logout

    # Users
    field :create_user, mutation: Mutations::Users::CreateUser
    field :update_user, mutation: Mutations::Users::UpdateUser
    field :withdraw_user, mutation: Mutations::Users::WithdrawUser

    # Follows
    field :create_follow, mutation: Mutations::Follows::CreateFollow
    field :delete_follow, mutation: Mutations::Follows::DeleteFollow

    # WhatToDiscardProblems
    field :create_what_to_discard_problem, mutation: Mutations::WhatToDiscardProblems::CreateWhatToDiscardProblem
    field :update_what_to_discard_problem, mutation: Mutations::WhatToDiscardProblems::UpdateWhatToDiscardProblem
    field :delete_what_to_discard_problem, mutation: Mutations::WhatToDiscardProblems::DeleteWhatToDiscardProblem

    field :create_what_to_discard_problem_comment, mutation: Mutations::WhatToDiscardProblems::CreateWhatToDiscardProblemComment
    field :delete_what_to_discard_problem_comment, mutation: Mutations::WhatToDiscardProblems::DeleteWhatToDiscardProblemComment

    field :create_what_to_discard_problem_vote, mutation: Mutations::WhatToDiscardProblems::CreateWhatToDiscardProblemVote
    field :delete_what_to_discard_problem_vote, mutation: Mutations::WhatToDiscardProblems::DeleteWhatToDiscardProblemVote

    field :create_what_to_discard_problem_like, mutation: Mutations::WhatToDiscardProblems::CreateWhatToDiscardProblemLike
    field :delete_what_to_discard_problem_like, mutation: Mutations::WhatToDiscardProblems::DeleteWhatToDiscardProblemLike

    field :create_what_to_discard_problem_bookmark, mutation: Mutations::WhatToDiscardProblems::CreateWhatToDiscardProblemBookmark
    field :delete_what_to_discard_problem_bookmark, mutation: Mutations::WhatToDiscardProblems::DeleteWhatToDiscardProblemBookmark
  end
end
