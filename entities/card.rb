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
      16.times.map { rand(10) }.join
    end
  end
end
