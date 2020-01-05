module Validators
  class Age < Validator
    def validate
      if @value.to_i <= 23 || @value.to_i >= 90
        @errors.push('Your Age must be greeter then 23 and lower then 90')
      end
    end
  end
end
