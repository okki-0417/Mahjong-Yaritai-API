# frozen_string_literal: true

module GraphqlHelper
  def execute_mutation(mutation, variables, context: {})
    context.each do |key, value|
      case key
      when :current_user
        allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(value)
      when :session
        allow_any_instance_of(GraphqlController).to receive(:session).and_return(value)
      end
    end

    post "/graphql", params: { query: mutation, variables: }, as: :json
  end
end
