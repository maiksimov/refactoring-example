module States
  class Initial < State
    def action
      puts I18n.t('run')
      @context.load_accounts
    end
  end
end
