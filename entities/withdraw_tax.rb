module Entities
  class WithdrawTax < Tax
    def tax(amount)
      case @type
      when 'usual' then amount * 0.05
      when 'capitalist' then amount * 0.04
      when 'virtual' then amount * 0.88
      else
      0
      end
    end
  end
end
