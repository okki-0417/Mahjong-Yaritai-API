# frozen_string_literal: true

module Sources
  class AssociationSource < GraphQL::Dataloader::Source
    def initialize(model, association_name)
      @model = model
      @association_name = association_name
    end

    def fetch(ids)
      records = @model.where(id: ids).includes(@association_name)
      # We return results in the same order as the input ids
      records_by_id = records.index_by(&:id)
      ids.map { |id| records_by_id[id] }
    end
  end
end
