class CardFactory
  CARD_TYPES = {
    usual: {
      type: 'usual',
      balance: 50.00
    },
    capitalist: {
      type: 'capitalist',
      balance: 100.00
    },
    virtual: {
      type: 'virtual',
      balance: 150.00
    }
  }.freeze

  def self.card(card_type)
    return false unless CARD_TYPES.key?(card_type)

    Entities::Card.new(CARD_TYPES[card_type])
  end
end
