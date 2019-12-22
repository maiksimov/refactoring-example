module Entities
  class Account
    attr_reader :login, :name, :password, :age, :errors
    attr_accessor :card

    def initialize(name:, login:, password:, age:, accounts:)
      @name = name
      @login = login
      @password = password
      @age = age
      @accounts = accounts
      @card = []
      @errors = []
    end

    def validated?
      @errors = []
      validate
      @errors.empty?
    end

    def validate
      unless @name != '' && @name[0].upcase == @name[0]
        @errors.push('Your name must not be empty and starts with first upcase letter')
      end

      if @login == ''
        @errors.push('Login must present')
      end
      if @login.length < 4
        @errors.push('Login must be longer then 4 symbols')
      end
      if @login.length > 20
        @errors.push('Login must be shorter then 20 symbols')
      end
      if @accounts.map { |a| a.login }.include? @login
        @errors.push('Such account is already exists')
      end

      if @password == ''
        @errors.push('Password must present')
      end
      if @password.length < 6
        @errors.push('Password must be longer then 6 symbols')
      end
      if @password.length > 30
        @errors.push('Password must be shorter then 30 symbols')
      end


      if @age.to_i.is_a?(Integer) && @age.to_i >= 23 && @age.to_i <= 90
        @age = @age.to_i
      else
        @errors.push('Your Age must be greeter then 23 and lower then 90')
      end
    end
  end
end
