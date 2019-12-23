module States
  class CreateAccount < State
    def action
      loop do
        @context.current_account = Entities::Account.new(name: name_input,
                                                         age: age_input,
                                                         login: login_input,
                                                         password: password_input,
                                                         accounts: @context.accounts)
        break if @context.current_account.validated?

        @context.current_account.errors.each do |error|
          puts error
        end
      end
      @context.accounts << @context.current_account
      @context.save
    end

    def next
      AccountMenu.new(@context)
    end

    def name_input
      puts 'Enter your name'
      read_input
    end

    def login_input
      puts 'Enter your login'
      read_input
    end

    def password_input
      puts 'Enter your password'
      read_input
    end

    def age_input
      puts 'Enter your age'
      read_input
    end
  end
end
