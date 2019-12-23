module CodebreakerConsole
  module Validators
    class Validator
      attr_reader :errors
      attr_reader :value

      def initialize(value)
        @value = value
        @errors = []
      end

      def validate?
        errors.empty?
      end
    end
  end
end
