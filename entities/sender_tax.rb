module Entities
  class SenderTax < Tax
    def tax(amount)
      case @type
      when 'usual' then 20
      when 'capitalist' then amount * 0.1
      when 'virtual' then 1
      else
      0
      end
    end
  end
end
