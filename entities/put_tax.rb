module Entities
  class PutTax < Tax
    def tax(amount)
      case @type
      when 'usual' then amount * 0.02
      when 'capitalist' then 10
      when 'virtual' then 1
      else
      0
      end
    end
  end
end
