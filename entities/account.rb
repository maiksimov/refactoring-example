module Entities
  class Account
    attr_reader :login, :name, :password, :age
    attr_accessor :card

    def initialize(name:, login:, password:, age:)
      @name = name
      @login = login
      @password = password
      @age = age
      @card = []
    end
  end
end
