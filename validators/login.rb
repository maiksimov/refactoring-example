module Validators
  class Login < Validator
    def initialize(value, accounts)
      @value = value
      @accounts = accounts
      @errors = []
    end

    def validate
      @errors.push('Login must present') if @value == ''
      @errors.push('Login must be longer then 4 symbols') if @value.length < 4
      @errors.push('Login must be shorter then 20 symbols') if @value.length > 20
      @errors.push('Such account is already exists') if @accounts.any? { |a| a.login == @value }
    end
  end
end
