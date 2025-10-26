# frozen_string_literal: true

module Mutations
  module WhatToDiscardProblems
    class Create < BaseMutation
      graphql_name "CreateWhatToDiscardProblem"

      include Authenticatable

      field :what_to_discard_problem, Types::WhatToDiscardProblemType, null: false

      argument :description, String, required: false
      argument :round, String, required: false
      argument :turn, Integer, required: false
      argument :wind, String, required: false
      argument :points, Integer, required: false
      argument :dora_id, ID, required: false
      argument :hand1_id, ID, required: false
      argument :hand2_id, ID, required: false
      argument :hand3_id, ID, required: false
      argument :hand4_id, ID, required: false
      argument :hand5_id, ID, required: false
      argument :hand6_id, ID, required: false
      argument :hand7_id, ID, required: false
      argument :hand8_id, ID, required: false
      argument :hand9_id, ID, required: false
      argument :hand10_id, ID, required: false
      argument :hand11_id, ID, required: false
      argument :hand12_id, ID, required: false
      argument :hand13_id, ID, required: false
      argument :tsumo_id, ID, required: false

      def resolve(
        description: nil,
        round: nil,
        turn: nil,
        wind: nil,
        points: nil,
        dora_id:,
        hand1_id:,
        hand2_id:,
        hand3_id:,
        hand4_id:,
        hand5_id:,
        hand6_id:,
        hand7_id:,
        hand8_id:,
        hand9_id:,
        hand10_id:,
        hand11_id:,
        hand12_id:,
        hand13_id:,
        tsumo_id:
      )
        raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

        problem = context[:current_user].created_what_to_discard_problems.new(
          description:,
          round:,
          turn:,
          wind:,
          points:,
          dora_id:,
          hand1_id:,
          hand2_id:,
          hand3_id:,
          hand4_id:,
          hand5_id:,
          hand6_id:,
          hand7_id:,
          hand8_id:,
          hand9_id:,
          hand10_id:,
          hand11_id:,
          hand12_id:,
          hand13_id:,
          tsumo_id:,
        )

        if problem.save
          { what_to_discard_problem: problem }
        else
          problem.errors.full_messages.each do |message|
            context.add_error(GraphQL::ExecutionError.new(message))
          end
          nil
        end
      end
    end
  end
end
