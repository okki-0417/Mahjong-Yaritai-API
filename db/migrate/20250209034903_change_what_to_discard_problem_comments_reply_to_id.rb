class ChangeWhatToDiscardProblemCommentsReplyToId < ActiveRecord::Migration[7.2]
  def up
    rename_column :what_to_discard_problem_comments, :reply_to_comment_id, :parent_comment_id
    change_column :what_to_discard_problem_comments, :parent_comment_id, :bigint
  end

  def down
    change_column :what_to_discard_problem_comments, :parent_comment_id, :bigint
    rename_column :what_to_discard_problem_comments, :parent_comment_id, :reply_to_comment_id
  end
end
