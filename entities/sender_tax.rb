module Entities
  class SenderTax < Tax
    def tax(amount)
      case @type
      when USUAL_TYPE then 20
      when CAPITALIST_TYPE then amount * 0.1
      when VIRTUAL_TYPE then 1
      else
      0
      end
    end
  end
end
