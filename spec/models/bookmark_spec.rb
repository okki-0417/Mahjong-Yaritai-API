# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bookmark, type: :model do
  describe "バリデーション" do
    let(:user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem) }

    it "同じユーザーが同じ問題を複数回お気に入りできない" do
      bookmark1 = user.created_bookmarks.create(bookmarkable: problem)
      expect(bookmark1).to be_valid

      bookmark2 = user.created_bookmarks.build(bookmarkable: problem)
      expect(bookmark2).not_to be_valid
      expect(bookmark2.errors[:user_id]).to include("はすでに存在します")
    end

    it "異なるユーザーなら同じ問題をお気に入りできる" do
      user2 = create(:user)

      bookmark1 = user.created_bookmarks.create(bookmarkable: problem)
      expect(bookmark1).to be_valid

      bookmark2 = user2.created_bookmarks.create(bookmarkable: problem)
      expect(bookmark2).to be_valid
    end

    it "自分が作成した問題はブックマークできない" do
      own_problem = create(:what_to_discard_problem, user: user)

      bookmark = user.created_bookmarks.build(bookmarkable: own_problem)
      expect(bookmark).not_to be_valid
      expect(bookmark.errors[:base]).to include("自分の問題はブックマークできません")
    end

    it "他人が作成した問題はブックマークできる" do
      other_user = create(:user)
      other_problem = create(:what_to_discard_problem, user: other_user)

      bookmark = user.created_bookmarks.build(bookmarkable: other_problem)
      expect(bookmark).to be_valid
    end
  end

  describe "カウンターキャッシュ" do
    let(:user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem) }

    it "お気に入り登録時にbookmarks_countが増える" do
      expect {
        user.created_bookmarks.create!(bookmarkable: problem)
        problem.reload
      }.to change { problem.bookmarks_count }.by(1)
    end

    it "お気に入り削除時にbookmarks_countが減る" do
      bookmark = user.created_bookmarks.create!(bookmarkable: problem)
      problem.reload

      expect {
        bookmark.destroy
        problem.reload
      }.to change { problem.bookmarks_count }.by(-1)
    end
  end
end
