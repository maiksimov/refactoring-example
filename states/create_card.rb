module States
  class CreateCard < State
    USUAL_CARD = 'usual'.freeze
    CAPITALIST_CARD = 'capitalist'.freeze
    VIRTUAL_CARD = 'virtual'.freeze

    def action
      loop do
        puts 'You could create one of 3 card types'
        puts '- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money. For creation this card - press `usual`'
        puts '- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. 4$ tax on WITHDRAWING money. For creation this card - press `capitalist`'
        puts '- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. 12% tax on WITHDRAWING money. For creation this card - press `virtual`'
        puts '- For exit - press `exit`'
        card = case read_input
               when USUAL_CARD
                 Entities::Card.new(
                     type: USUAL_CARD,
                     number: 16.times.map{rand(10)}.join,
                     balance: 50.00
                 )
               when CAPITALIST_CARD
                 Entities::Card.new(
                     type: CAPITALIST_CARD,
                     number: 16.times.map{rand(10)}.join,
                     balance: 100.00
                 )
               when VIRTUAL_CARD
                 Entities::Card.new(
                     type: VIRTUAL_CARD,
                     number: 16.times.map{rand(10)}.join,
                     balance: 150.00
                 )
               else
                 puts I18n.t('wrong_card_type')
                 next
               end

        @context.current_account.card << card
        @context.save
        break
      end
    end
  end
end
