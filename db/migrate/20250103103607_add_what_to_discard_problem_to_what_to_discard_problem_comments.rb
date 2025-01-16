class AddWhatToDiscardProblemToWhatToDiscardProblemComments < ActiveRecord::Migration[7.2]
  def change
    add_reference :what_to_discard_problem_comments, :what_to_discard_problem, null: false, foreign_key: true
  end
end
