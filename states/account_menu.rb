module States
  class AccountMenu < State
    def action
      puts I18n.t('menu', name: @context.current_account.name)
    end
  end
end
