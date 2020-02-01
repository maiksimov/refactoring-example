module States
  class LoadAccount < State
    def action
      if @context.accounts.empty?
        puts I18n.t('no_active_accounts')
        return @answer = read_input
      end

      login = read_login
      password = read_password
      @context.current_account = get_account(login, password)
      puts I18n.t('no_account') unless @context.current_account
    end

    def next
      return CreateAccount.new(@context) if @answer == AGREE_COMMAND
      return Initial.new(@context) if @context.accounts.empty? && @answer != AGREE_COMMAND

      AccountMenu.new(@context)
    end

    private

    def read_login
      puts I18n.t('enter_login')
      read_input
    end

    def read_password
      puts I18n.t('enter_password')
      read_input
    end

    def get_account(login, password)
      @context.accounts.detect { |account| account.login == login && account.password == password }
    end
  end
end
