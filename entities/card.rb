module Entities
  class Card
    attr_reader :errors
    attr_accessor :type, :number, :balance

    def initialize(type:, number:, balance:)
      @type = type
      @number = number
      @balance = balance
      @errors = []
    end

    def validated?
      @errors = []
      validate
      @errors.empty?
    end

    def validate

    end
  end
end
