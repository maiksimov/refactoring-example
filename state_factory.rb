class StateFactory
  CREATE_ACCOUNT_COMMAND = 'create'.freeze
  SHOW_CARDS_COMMAND = 'SC'.freeze
  CREATE_CARD_COMMAND = 'CC'.freeze

  DELETE_CARD_COMMAND = 'DC'.freeze
  PUT_MONEY_COMMAND = 'PM'.freeze
  WITHDRAW_MONEY_COMMAND = 'WM'.freeze
  SEND_MONEY_COMMAND = 'SM'.freeze
  CREATE_ACCOUNT_COMMAND = 'create'.freeze
  LOAD_ACCOUNT_COMMAND = 'load'.freeze
  DELETE_ACCOUNT_COMMAND = 'DA'.freeze

  def state(command, context)
    case command
    when CREATE_ACCOUNT_COMMAND then States::CreateAccount.new(context)
    when LOAD_ACCOUNT_COMMAND then States::LoadAccount.new(context)
    when SHOW_CARDS_COMMAND then States::ShowCards.new(context)
    when CREATE_CARD_COMMAND then States::CreateCard.new(context)
    else
      States::WrongCommand.new(context)
    end
  end
end
