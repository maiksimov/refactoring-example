module States
  class State
    AGREE_COMMAND = 'y'.freeze
    EXIT_COMMAND = 'exit'.freeze

    def initialize(context)
      @context = context
    end

    def action
      raise NotImplementedError
    end

    def next
      StateFactory.new.state(read_input, @context)
    end

    def read_input
      input = STDIN.gets.chomp
      raise ExitError if input == EXIT_COMMAND

      input
    end

    def amount_valid?(amount)
      return true if amount.positive?

      puts I18n.t('wrong_money_amount')
      false
    end

    def withdraw_stats(amount, card, balance, tax)
      puts I18n.t('withdraw_stats',
                  amount: amount,
                  current_card: card,
                  balance: balance,
                  tax: tax)
    end

    def balance_valid?(balance)
      return true unless balance.negative?

      puts I18n.t('no_money')
      false
    end

    def put_stats(amount, card, balance, tax)
      puts I18n.t('put_stats',
                  amount: amount,
                  current_card: card,
                  balance: balance,
                  tax: tax)
    end

    def card_index_valid?(selected_card_index)
      return true if selected_card_index.between?(1, @context.current_account.card.length)

      puts I18n.t('choose_correct_card')
      false
    end

    def print_cards(cards, title = false)
      puts title if title

      cards.each_with_index do |card, i|
        puts I18n.t('select_card', card_number: card.number, card_type: card.type, index: (i + 1))
      end
      puts I18n.t('exit')
    end

    def account_have_cards?(cards)
      return true if cards.any?

      puts I18n.t('no_active_cards')
      false
    end

    def read_input_with_title(title)
      puts title

      read_input
    end

    def save_context
      @context.save
    end
  end
end
