module States
  class PutMoney < State
    def action
      puts I18n.t('choose_card')
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
      current_card = @context.current_account.card[selected_card_index]
      read_amount_step(selected_card_index, current_card)
    end

    def read_amount_step(selected_card_index, current_card)
      input_amount = read_input_with_title(I18n.t('put_amount')).to_i
      return unless amount_valid?(input_amount)

      read_tax_step(selected_card_index, current_card, input_amount)
    end

    def read_tax_step(selected_card_index, current_card, input_amount)
      tax = put_tax(current_card.type, input_amount)
      return unless tax_valid?(tax, input_amount)

      current_card.balance = current_card.balance + input_amount - tax
      @context.current_account.card[selected_card_index] = current_card
      @context.save
      put_stats(input_amount, current_card.number, current_card.balance, tax)
    end

    def tax_valid?(tax, amount)
      return true if tax < amount

      puts I18n.t('wrong_higher_tax')
      false
    end

    def put_tax(type, amount)
      Entities::PutTax.new(type).tax(amount)
    end
  end
end
