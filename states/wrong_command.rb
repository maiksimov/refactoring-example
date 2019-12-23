module States
  class WrongCommand < State
    def action
      puts I18n.t('wrong_command')
    end
  end
end
