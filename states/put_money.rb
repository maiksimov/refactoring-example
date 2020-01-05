module States
  class PutMoney < State
    def action
      puts I18n.t('choose_card')

      if @context.current_account.card.empty?
        puts I18n.t('no_active_cards')
        return
      end

      @context.current_account.card.each_with_index do |card, i|
        puts I18n.t('select_card', card_number: card.number, card_type: card.type, index: (i + 1))
      end

      puts I18n.t('exit')

      selected_card = read_input.to_i

      unless selected_card <= @context.current_account.card.length && selected_card > 0
        puts I18n.t('wrong_number')
        return
      end
      selected_card -= 1

      current_card = @context.current_account.card[selected_card]

      puts I18n.t('put_amount')
      input_amount = read_input.to_i

      unless input_amount > 0
        puts I18n.t('wrong_money_amount')
        return
      end

      tax = put_tax(current_card.type, input_amount)

      if tax >= input_amount
        puts I18n.t('wrong_higher_tax')
        return
      end

      new_money_amount = current_card.balance + input_amount - tax
      current_card.balance = new_money_amount
      @context.current_account.card[selected_card] = current_card
      @context.save
      puts I18n.t('put_stats',
                  amount: input_amount,
                  current_card: current_card.number,
                  balance: current_card.balance,
                  tax: tax)
    end

    def next
      AccountMenu.new(@context)
    end

    private

    def put_tax(type, amount)
      Entities::PutTax.new(type).tax(amount)
    end
  end
end
