module Entities
  class Card
    attr_accessor :type, :number, :balance, :tax

    def initialize(type:, number:, balance:, tax: 0)
      @type = type
      @number = number
      @balance = balance
      @tax = tax
    end
  end
end
