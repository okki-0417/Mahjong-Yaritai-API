class RenameWhatToDiscardProblemFavoritesTableToWhatToDiscardProblemLikes < ActiveRecord::Migration[7.2]
  def change
    rename_table :what_to_discard_problem_favorites, :what_to_discard_problem_likes
  end
end
