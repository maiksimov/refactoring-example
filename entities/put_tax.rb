module Entities
  class PutTax < Tax
    def tax(amount)
      case @type
      when USUAL_TYPE then amount * 0.02
      when CAPITALIST_TYPE then 10
      when VIRTUAL_TYPE then 1
      else
        default_tax
      end
    end
  end
end
