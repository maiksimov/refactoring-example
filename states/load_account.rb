module States
  class LoadAccount < State
    AGREE_COMMAND = 'y'.freeze

    def action
      if @context.accounts.empty?
        puts I18n.t('no_active_accounts')
        @answer = read_input
        return
      end

      puts I18n.t('enter_login')
      login = read_input
      puts I18n.t('enter_password')
      password = read_input

      unless @context.accounts.map { |account| { login: account.login, password: account.password } }.include?({ login: login, password: password })
        puts I18n.t('no_account')
        return
      end

      @context.current_account = @context.accounts.select { |account| login == account.login }.first
    end

    def next
      return CreateAccount.new(@context) if @answer == AGREE_COMMAND
      return Initial.new(@context) if @context.accounts.empty? && @answer != AGREE_COMMAND

      AccountMenu.new(@context)
    end
  end
end
