module Entities
  class WithdrawTax < Tax
    def tax(amount)
      case @type
      when USUAL_TYPE then amount * 0.05
      when CAPITALIST_TYPE then amount * 0.04
      when VIRTUAL_TYPE then amount * 0.88
      else
        0
      end
    end
  end
end
