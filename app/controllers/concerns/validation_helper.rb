module ValidationHelper
  def validate_params!(schema, params)
    validation = schema.call(params.to_h)

    unless validation.success?
      message = format_message(validation)
      raise ::CustomErrors::InvalidParams, message
    end

    @valid_params = validation.to_h
  end

  protected

  def format_message(validation)
    validation.errors(full: true).messages.joins(', ')
  end

  attr_reader :valid_params
end