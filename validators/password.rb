module Validators
  class Password < Validator
    def validate
      if @value == ''
        @errors.push('Password must present')
      end
      if @value.length < 6
        @errors.push('Password must be longer then 6 symbols')
      end
      if @value.length > 30
        @errors.push('Password must be shorter then 30 symbols')
      end
    end
  end
end
