# frozen_string_literal: true

module ErrorJsonRenderable
  def validation_error_json(model)
    { errors: model.errors.full_messages.map { |message| { message: } } }
  end
end
