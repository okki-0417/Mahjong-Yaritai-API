# frozen_string_literal: true

require "rails_helper"

RSpec.describe CursorPaginationable do
  describe "query_with_cursor_pagination" do
    let(:dummy_class) { Class.new { include CursorPaginationable } }
    let(:relation) { WhatToDiscardProblem.all }
    let(:cursor) { 5 }
    let(:limit) { 20 }

    let(:count) { 30 }
    before { create_list(:what_to_discard_problem, count) }

    subject { dummy_class.new.query_with_cursor_pagination(relation, cursor:, limit:) }

    context "cursorとlimitを指定した場合" do
      context "次のページがある場合" do
        it "クエリを渡すとレコードとページネーション情報が返ってくること" do
          result = subject
          expect(result).to include(:edges, :page_info)
          expect(result[:edges].size).to eq(limit)
          expect(result[:page_info]).to include(:has_next_page, :end_cursor, :limit)
          expect(result[:page_info][:has_next_page]).to be true
          expect(result[:page_info][:end_cursor]).to eq(result[:edges].last.id)
          expect(result[:page_info][:limit]).to eq(limit)
        end
      end

      context "次のページがない場合" do
        let(:limit) { count - cursor }
        it "クエリを渡すとレコードとページネーション情報が返ってくること" do
          result = subject
          expect(result).to include(:edges, :page_info)
          expect(result[:edges].size).to eq(2)
          expect(result[:page_info]).to include(:has_next_page, :end_cursor, :limit)
          expect(result[:page_info][:has_next_page]).to be false
          expect(result[:page_info][:end_cursor]).to eq(nil)
          expect(result[:page_info][:limit]).to eq(limit)
        end
      end
    end

    context "cursorだけ指定された場合" do
      let(:limit) { nil }
      it "全てのレコードが返ること" do
        expect(subject).to include(:edges, :page_info)
        expect(subject[:edges].size).to eq(count)
        expect(subject[:page_info]).to include(:has_next_page, :end_cursor, :limit)
        expect(subject[:page_info][:has_next_page]).to be false
        expect(subject[:page_info][:end_cursor]).to eq(nil)
        expect(subject[:page_info][:limit]).to eq(count)
      end
    end

    context "cursorがない場合" do
      let(:cursor) { nil }
      it "最初のページが返ること" do
        expect(subject).to include(:edges, :page_info)
        expect(subject[:edges].size).to eq(limit)
        expect(subject[:page_info]).to include(:has_next_page, :end_cursor, :limit)
        expect(subject[:page_info][:has_next_page]).to be true
        expect(subject[:page_info][:end_cursor]).to eq(subject[:edges].last.id)
        expect(subject[:page_info][:limit]).to eq(limit)
      end
    end
  end
end
