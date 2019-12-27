module States
  class CreateCard < State
    USUAL_CARD = 'usual'.freeze
    CAPITALIST_CARD = 'capitalist'.freeze
    VIRTUAL_CARD = 'virtual'.freeze

    def action
      puts I18n.t('create_card')
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
               return @wrong_card = true
             end

      @context.current_account.card << card
      @context.save
    end

    def next
      return CreateCard.new(@context) if @wrong_card

      AccountMenu.new(@context)
    end
  end
end
