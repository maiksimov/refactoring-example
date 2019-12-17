module Entities
  class Account
    attr_reader :login, :name, :password

    def initialize(name:, login:, password:)
      @name = name
      @login = login
      @password = password
    end
  end
end
