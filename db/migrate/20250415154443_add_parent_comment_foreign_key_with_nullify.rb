class AddParentCommentForeignKeyWithNullify < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :what_to_discard_problem_comments, :what_to_discard_problem_comments,
                    column: :parent_comment_id,
                    on_delete: :nullify
  end
end
