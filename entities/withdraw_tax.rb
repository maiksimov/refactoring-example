module Entities
  class WithdrawTax < Tax
    TAXES = {
      USUAL_TYPE: 0.05,
      CAPITALIST_TYPE: 0.04,
      VIRTUAL_TYPE: 0.88
    }.freeze

    def tax(amount)
      return amount * TAXES[@type] if TAXES.key?(@type)

      default_tax
    end
  end
end
