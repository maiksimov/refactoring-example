module Validators
  class Age < Validator
    def validate
      @errors.push('Your Age must be greeter then 23 and lower then 90') unless @value.to_i.between?(23, 89)
    end
  end
end
