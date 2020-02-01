module States
  class DeleteAccount < State
    def action
      puts I18n.t('destroy_account')
      @answer = read_input
      return unless @answer == AGREE_COMMAND

      @context.accounts.delete_if { |account| account.login == @context.current_account.login }
      @context.save
    end

    def next
      return Initial.new(@context) if @answer == AGREE_COMMAND

      AccountMenu.new(@context)
    end
  end
end
