module States
  class WithdrawMoney < State
    def action
      puts I18n.t('withdrawing_card')
      if @context.current_account.card.empty?
        puts I18n.t('no_active_cards')
        return
      end

      @context.current_account.card.each_with_index do |card, i|
        puts I18n.t('select_card', card_number: card.number, card_type: card.type, index: (i + 1))
      end

      puts I18n.t('exit')
      selected_card_index = read_input.to_i

      unless selected_card_index <= @context.current_account.card.length && selected_card_index > 0
        puts I18n.t('wrong_number')
        return
      end

      selected_card_index -= 1
      current_card = @context.current_account.card[selected_card_index]
      puts I18n.t('withdraw_amount')
      amount = read_input.to_i

      if amount <= 0
        puts I18n.t('correct_amount')
        return
      end

      withdraw_tax_amount = withdraw_tax(current_card.type, amount)
      money_left = current_card.balance - amount - withdraw_tax_amount

      if money_left <= 0
        puts I18n.t('no_money')
        return
      end

      current_card.balance = money_left
      @context.current_account.card[selected_card_index] = current_card
      @context.save
      puts I18n.t('withdraw_stats',
                  amount: amount,
                  current_card: current_card.number,
                  balance: current_card.balance,
                  tax: withdraw_tax_amount)
    end

    def next
      AccountMenu.new(@context)
    end

    private

    def withdraw_tax(type, amount)
      Entities::WithdrawTax.new(type).tax(amount)
    end
  end
end
