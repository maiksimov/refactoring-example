module Entities
  class SenderTax < Tax
    TAXES = {
      USUAL_TYPE: 0.05,
      CAPITALIST_TYPE: 0.1,
      VIRTUAL_TYPE: 0.88
    }.freeze

    def tax(amount)
      case @type
      when USUAL_TYPE then 20
      when CAPITALIST_TYPE then amount * 0.1
      when VIRTUAL_TYPE then 1
      else
        default_tax
      end
    end
  end
end
