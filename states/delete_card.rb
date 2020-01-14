module States
  class DeleteCard < State
    MENU_STATE = 'menu'.freeze

    def action
      return @next_state = MENU_STATE unless account_have_cards?(@context.current_account.card)

      select_card
    end

    def next
      return AccountMenu.new(@context) if @next_state == MENU_STATE

      DeleteCard.new(@context)
    end

    private

    def select_card
      print_cards(@context.current_account.card, I18n.t('delete_question'))
      selected_card_index = read_input.to_i
      return unless card_index_valid?(selected_card_index)

      agree_to_delete_cart(selected_card_index)
    end

    def agree_to_delete_cart(selected_card_index)
      puts I18n.t('delete_card_question', card_number: @context.current_account.card[selected_card_index - 1].number)
      return unless read_input == AGREE_COMMAND

      delete_cart(selected_card_index)
      save_context
    end

    def delete_cart(selected_card_index)
      @context.current_account.card.delete_at(selected_card_index - 1)
    end
  end
end
