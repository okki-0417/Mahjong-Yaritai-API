# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_what_to_discard_problem_vote, mutation: Mutations::CreateWhatToDiscardProblemVote
    field :delete_what_to_discard_problem_vote, mutation: Mutations::DeleteWhatToDiscardProblemVote

    field :create_what_to_discard_problem_like, mutation: Mutations::CreateWhatToDiscardProblemLike
    field :delete_what_to_discard_problem_like, mutation: Mutations::DeleteWhatToDiscardProblemLike

    field :create_what_to_discard_problem_bookmark, mutation: Mutations::CreateWhatToDiscardProblemBookmark
    field :delete_what_to_discard_problem_bookmark, mutation: Mutations::DeleteWhatToDiscardProblemBookmark

    field :create_follow, mutation: Mutations::CreateFollow
    field :delete_follow, mutation: Mutations::DeleteFollow

    field :create_comment, mutation: Mutations::CreateComment
    field :delete_comment, mutation: Mutations::DeleteComment

    field :create_what_to_discard_problem, mutation: Mutations::CreateWhatToDiscardProblem
    field :update_what_to_discard_problem, mutation: Mutations::UpdateWhatToDiscardProblem
    field :delete_what_to_discard_problem, mutation: Mutations::DeleteWhatToDiscardProblem

    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :withdraw_user, mutation: Mutations::WithdrawUser

    field :request_auth, mutation: Mutations::RequestAuth
    field :verify_auth, mutation: Mutations::VerifyAuth
    field :logout, mutation: Mutations::Logout
  end
end
