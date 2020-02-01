module Validators
  class Password < Validator
    def validate
      @errors.push('Password must present') if @value == ''
      @errors.push('Password must be longer then 6 symbols') if @value.length < 6
      @errors.push('Password must be shorter then 30 symbols') if @value.length > 30
    end
  end
end
