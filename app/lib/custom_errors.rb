module CustomErrors
  class BaseError < StandardError
    def initialize(message = nil)
      super message
    end
  end

  class InvalidParams < BaseError; end
end