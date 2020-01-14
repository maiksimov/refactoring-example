module States
  class SendMoney < State
    def action
      puts I18n.t('choose_sending_card')
      return unless account_have_cards?(@context.current_account.card)

      select_card_step
    end

    def next
      AccountMenu.new(@context)
    end

    private

    def select_card_step
      print_cards(@context.current_account.card, I18n.t('delete_question'))
      selected_card_index = read_input.to_i
      return unless card_index_valid?(selected_card_index, @context)

      selected_card_index -= 1
      @sender_card = @context.current_account.card[selected_card_index]

      recipient_card_number_step
    end

    def recipient_card_number_step
      @recipient_card_number = read_input_with_title(I18n.t('recipient_card'))
      return unless card_length_valid?(@recipient_card_number)

      recipient_card_step
    end

    def recipient_card_step
      @recipient_card = card_by_number(@recipient_card_number)
      return unless card_exists?(@recipient_card, @recipient_card_number)

      amount_step
    end

    def amount_step
      @amount = read_input_with_title(I18n.t('withdraw_amount')).to_i
      return unless amount_valid?(@amount)

      taxes_step
    end

    def taxes_step
      @sender_tax_amount = sender_tax(@sender_card.type, @amount)
      @recipient_tax_amount = put_tax(@recipient_card.type, @amount)
      @sender_balance = @sender_card.balance - @amount - @sender_tax_amount
      @recipient_balance = @recipient_card.balance + @amount - @recipient_tax_amount
      return unless balance_valid?(@sender_balance)
      return unless recipient_tax_valid?(@recipient_tax_amount, @amount)

      save_balances_step
    end

    def save_balances_step
      @sender_card.balance = @sender_balance
      @recipient_card.balance = @recipient_balance
      @context.save
      withdraw_stats(@amount, @sender_card.number, @sender_balance, @sender_tax_amount)
      put_stats(@amount, @recipient_card_number, @recipient_balance, @recipient_tax_amount)
    end

    def recipient_tax_valid?(recipient_tax_amount, input_amount)
      return true if recipient_tax_amount < input_amount

      puts I18n.t('no_money_on_sender_card')
      false
    end

    def card_by_number(card_number)
      @context.accounts.map(&:card).flatten.detect { |card| card.number == card_number }
    end

    def card_exists?(card, card_number)
      return true unless card.nil?

      puts I18n.t('no_card_with_number', number: card_number)
      false
    end

    def card_length_valid?(card_number)
      return true if card_number.length.between?(15, 17)

      puts I18n.t('not_correct_card_number')
      false
    end

    def put_tax(type, amount)
      Entities::PutTax.new(type).tax(amount)
    end

    def sender_tax(type, amount)
      Entities::SenderTax.new(type).tax(amount)
    end
  end
end
