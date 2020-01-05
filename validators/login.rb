module Validators
  class Login < Validator
    def initialize(value, accounts)
      @value = value
      @accounts = accounts
      @errors = []
    end

    def validate
      if @value == ''
        @errors.push('Login must present')
      end
      if @value.length < 4
        @errors.push('Login must be longer then 4 symbols')
      end
      if @value.length > 20
        @errors.push('Login must be shorter then 20 symbols')
      end
      if @accounts.map { |a| a.login }.include? @value
        @errors.push('Such account is already exists')
      end
    end
  end
end
