module Entities
  class Card
    attr_accessor :type, :number, :balance, :tax

    def initialize(type:, balance:, tax: 0)
      @type = type
      @number = generate_card_number
      @balance = balance
      @tax = tax
    end

    private

    def generate_card_number
      Array.new(16) { rand(10) }
    end
  end
end
