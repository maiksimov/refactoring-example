module States
  class DeleteCard < State
    AGREE_COMMAND = 'y'.freeze
    MENU_STATE = 'menu'.freeze

    def action
      if @context.current_account.card.empty?
        puts I18n.t('no_active_cards')
        return @next_state = MENU_STATE
      end

      puts I18n.t('delete_question')
      @context.current_account.card.each_with_index do |card, i|
        puts I18n.t('select_card', card_number: card.number, card_type: card.type, index: (i + 1))
      end
      puts I18n.t('exit')
      @selected_card_index = read_input.to_i

      unless card_index_valid?(@selected_card_index)
        puts I18n.t('wrong_number')
        return
      end

      puts I18n.t('delete_card_question', card_number: @context.current_account.card[@selected_card_index - 1].number)
      @answer = read_input

      return unless @answer == AGREE_COMMAND

      @context.current_account.card.delete_at(@selected_card_index - 1)
      @context.save
    end

    def next
      return AccountMenu.new(@context) if @next_state == MENU_STATE

      DeleteCard.new(@context)
    end

    private

    def card_index_valid?(selected_card_index)
      selected_card_index <= @context.current_account.card.length && selected_card_index > 0
    end
  end
end
