class RemoveParentCommentForeignKey < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :what_to_discard_problem_comments, column: :parent_comment_id
  end
end
