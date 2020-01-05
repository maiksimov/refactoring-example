module States
  class SendMoney < State
    def action
      puts I18n.t('choose_sending_card')

      if @context.current_account.card.empty?
        puts I18n.t('no_active_cards')
        return
      end

      @context.current_account.card.each_with_index do |card, i|
        puts I18n.t('select_card', card_number: card.number, card_type: card.type, index: (i + 1))
      end

      puts I18n.t('exit')

      selected_card = read_input

      unless selected_card.to_i <= @context.current_account.card.length && selected_card.to_i > 0
        puts I18n.t('choose_correct_card')
        return
      end

      sender_card = @context.current_account.card[selected_card.to_i - 1]

      puts I18n.t('recipient_card')
      recipient_card_number = read_input

      if recipient_card_number.length < 15 || recipient_card_number.length > 17
        puts I18n.t('not_correct_card_number')
        return
      end

      all_cards = @context.accounts.map(&:card).flatten

      unless all_cards.select { |card| card.number == recipient_card_number }.any?
        puts I18n.t('no_card_with_number', number: recipient_card_number)
        return
      end

      recipient_card = all_cards.select { |card| card.number == recipient_card_number }.first

      puts I18n.t('withdraw_amount')
      amount = read_input.to_i

      if amount <= 0
        puts I18n.t('wrong_number')
        return
      end

      sender_tax_amount = sender_tax(sender_card.type, amount)
      recipient_tax_amount = put_tax(recipient_card.type, amount)

      sender_balance = sender_card.balance - amount - sender_tax_amount
      recipient_balance = recipient_card.balance + amount - recipient_tax_amount

      if sender_balance < 0
        puts I18n.t('no_money')
        return
      end

      if recipient_tax_amount >= amount
        puts I18n.t('no_money_on_sender_card')
        return
      end

      sender_card.balance = sender_balance
      recipient_card.balance = recipient_balance

      @context.save
      puts I18n.t('withdraw_stats',
                  amount: amount,
                  current_card: sender_card.number,
                  balance: sender_balance,
                  tax: sender_tax_amount)
      puts I18n.t('put_stats',
                  amount: amount,
                  current_card: recipient_card_number,
                  balance: recipient_balance,
                  tax: recipient_tax_amount)
    end

    def next
      AccountMenu.new(@context)
    end

    private

    def put_tax(type, amount)
      Entities::PutTax.new(type).tax(amount)
    end

    def sender_tax(type, amount)
      Entities::SenderTax.new(type).tax(amount)
    end
  end
end
