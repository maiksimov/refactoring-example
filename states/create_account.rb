module States
  class CreateAccount < State
    CREATE_ACCOUNT_STATE = 'create'.freeze
    def action
      @errors = []
      @context.current_account = Entities::Account.new(name: name_input,
                                                       age: age_input,
                                                       login: login_input,
                                                       password: password_input)
      return if errors?

      @context.accounts << @context.current_account
      @context.save
    end

    def next
      return CreateAccount.new(@context) if @next_state == CREATE_ACCOUNT_STATE

      AccountMenu.new(@context)
    end

    private

    def errors?
      return false if @errors.empty?

      @errors.each { |error| puts error }
      @next_state = CREATE_ACCOUNT_STATE
      true
    end

    def name_input
      puts 'Enter your name'
      validator = Validators::Name.new(read_input)
      validated_value(validator)
    end

    def login_input
      puts 'Enter your login'
      validator = Validators::Login.new(read_input, @context.accounts)
      validated_value(validator)
    end

    def password_input
      puts 'Enter your password'
      validator = Validators::Password.new(read_input)
      validated_value(validator)
    end

    def age_input
      puts 'Enter your age'
      validator = Validators::Age.new(read_input)
      validated_value(validator)
    end

    def validated_value(validator)
      @errors << validator.errors unless validator.validate?
      validator.value
    end
  end
end
