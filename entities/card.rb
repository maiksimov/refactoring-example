module Entities
  class Card
    attr_reader :errors
    attr_accessor :type, :number, :balance, :tax

    def initialize(type:, number:, balance:, tax: 0)
      @type = type
      @number = number
      @balance = balance
      @tax = tax
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
