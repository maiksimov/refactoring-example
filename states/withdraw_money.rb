module States
  class WithdrawMoney < State
    def action
      puts I18n.t('withdrawing_card')
      return unless account_have_cards?(@context.current_account.card)

      select_card_step
    end

    def next
      AccountMenu.new(@context)
    end

    private

    def select_card_step
      print_cards(@context.current_account.card)
      @selected_card_index = read_input.to_i
      return unless card_index_valid?(@selected_card_index)

      read_amount_step
    end

    def read_amount_step
      @selected_card_index -= 1
      @current_card = @context.current_account.card[@selected_card_index]
      @amount = read_input_with_title(I18n.t('withdraw_amount')).to_i
      return unless amount_valid?(@amount)

      tax_step
    end

    def tax_step
      @withdraw_tax_amount = withdraw_tax(@current_card.type, @amount)
      @money_left = @current_card.balance - @amount - @withdraw_tax_amount
      return unless balance_valid?(@money_left)

      save_balance_step
    end

    def save_balance_step
      @current_card.balance = @money_left
      @context.current_account.card[@selected_card_index] = @current_card
      @context.save
      withdraw_stats(@amount, @current_card.number, @money_left, @withdraw_tax_amount)
    end

    def withdraw_tax(type, amount)
      Entities::WithdrawTax.new(type).tax(amount)
    end
  end
end
