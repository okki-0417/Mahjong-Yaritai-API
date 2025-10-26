# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :request_auth, mutation: Mutations::Auth::RequestAuth
    field :verify_auth, mutation: Mutations::Auth::VerifyAuth
    field :logout, mutation: Mutations::Auth::Logout

    field :create_user, mutation: Mutations::Users::CreateUser
    field :update_user, mutation: Mutations::Users::UpdateUser
    field :withdraw_user, mutation: Mutations::Users::WithdrawUser

    field :create_follow, mutation: Mutations::Follows::CreateFollow
    field :delete_follow, mutation: Mutations::Follows::DeleteFollow

    field :create_what_to_discard_problem, mutation: Mutations::WhatToDiscardProblems::Create
    field :update_what_to_discard_problem, mutation: Mutations::WhatToDiscardProblems::Update
    field :delete_what_to_discard_problem, mutation: Mutations::WhatToDiscardProblems::Delete

    field :create_what_to_discard_problem_comment, mutation: Mutations::WhatToDiscardProblems::Comments::Create
    field :delete_what_to_discard_problem_comment, mutation: Mutations::WhatToDiscardProblems::Comments::Delete

    field :create_what_to_discard_problem_vote, mutation: Mutations::WhatToDiscardProblems::Votes::Create
    field :delete_what_to_discard_problem_vote, mutation: Mutations::WhatToDiscardProblems::Votes::Delete

    field :create_what_to_discard_problem_like, mutation: Mutations::WhatToDiscardProblems::Likes::Create
    field :delete_what_to_discard_problem_like, mutation: Mutations::WhatToDiscardProblems::Likes::Delete

    field :create_what_to_discard_problem_bookmark, mutation: Mutations::WhatToDiscardProblems::Bookmarks::Create
    field :delete_what_to_discard_problem_bookmark, mutation: Mutations::WhatToDiscardProblems::Bookmarks::Delete
  end
end
