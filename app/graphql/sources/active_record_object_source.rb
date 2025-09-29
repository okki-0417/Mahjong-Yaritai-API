# frozen_string_literal: true

module Sources
  class ActiveRecordObjectSource < GraphQL::Dataloader::Source
    def initialize(model)
      @model = model
    end

    def fetch(ids)
      records = @model.where(id: ids)
      records_by_id = records.index_by(&:id)
      ids.map { |id| records_by_id[id] }
    end
  end
end
