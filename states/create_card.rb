module States
  class CreateCard < State
    def action
      puts I18n.t('create_card')
      card = CardFactory.card(read_input.to_sym)
      if card == false
        puts I18n.t('wrong_card_type')
        return @wrong_card = true
      end

      @context.current_account.card << card
      @context.save
    end

    def next
      return CreateCard.new(@context) if @wrong_card

      AccountMenu.new(@context)
    end
  end
end
