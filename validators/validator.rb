module Validators
  class Validator
    attr_reader :errors
    attr_reader :value

    def initialize(value)
      @value = value
      @errors = []
    end

    def valid?
      @errors = []
      validate
      errors.empty?
    end

    def validate
      raise NotImplementedError 'Method validate wasn\'t implemented'
    end
  end
end
