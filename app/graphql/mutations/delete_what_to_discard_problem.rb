module Mutations
  class DeleteWhatToDiscardProblem < BaseMutation
    field :success, Boolean, null: false
    field :errors, [String], null: false

    argument :id, ID, required: true

    def resolve(id:)
      return { success: false, errors: ["ログインが必要です"] } unless context[:current_user]

      problem = context[:current_user].what_to_discard_problems.find_by(id: id)

      unless problem
        return { success: false, errors: ["問題が見つかりません"] }
      end

      if problem.destroy
        { success: true, errors: [] }
      else
        { success: false, errors: problem.errors.full_messages }
      end
    end
  end
end