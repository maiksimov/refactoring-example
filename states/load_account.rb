module States
  class CreateAccount < State
    def action
      loop do
        if @context.accounts.empty?
          puts I18n.t('no_active_accounts')
          @answer = read_input
          break
        end

        puts I18n.t('enter_login')
        login = read_input
        puts I18n.t('enter_password')
        password = read_input

        if @context.accounts.map { |account| { login: account.login, password: account.password } }.include?({ login: login, password: password })
          @context.current_account = @context.accounts.select { |account| login == account.login }.first
          break
        else
          puts I18n.t('no_account')
          next
        end
      end
    end

    def next

      return CreateAccount.new(@context) if @answer == AGREE_COMMAND
      return Initial.new(@context) if @context.accounts.empty? && @answer != AGREE_COMMAND

      AccountMenu.new(@context)
    end
  end
end
