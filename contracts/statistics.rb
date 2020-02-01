module Contracts
  module Statistics
    def withdraw_stats(amount, card, balance, tax)
      puts I18n.t('withdraw_stats',
                  amount: amount,
                  current_card: card,
                  balance: balance,
                  tax: tax)
    end

    def put_stats(amount, card, balance, tax)
      puts I18n.t('put_stats',
                  amount: amount,
                  current_card: card,
                  balance: balance,
                  tax: tax)
    end

    def print_cards(cards, title = false)
      puts title if title

      cards.each_with_index do |card, i|
        puts I18n.t('select_card', card_number: card.number, card_type: card.type, index: (i + 1))
      end
      puts I18n.t('exit')
    end
  end
end
