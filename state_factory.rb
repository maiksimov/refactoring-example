class StateFactory
  CREATE_ACCOUNT_COMMAND = 'create'.freeze
  LOAD_ACCOUNT_COMMAND = 'load'.freeze
  DELETE_ACCOUNT_COMMAND = 'DA'.freeze
  SHOW_CARDS_COMMAND = 'SC'.freeze
  CREATE_CARD_COMMAND = 'CC'.freeze
  DELETE_CARD_COMMAND = 'DC'.freeze
  PUT_MONEY_COMMAND = 'PM'.freeze
  WITHDRAW_MONEY_COMMAND = 'WM'.freeze
  SEND_MONEY_COMMAND = 'SM'.freeze

  def state(command, context)
    case command
    when CREATE_ACCOUNT_COMMAND then States::CreateAccount.new(context)
    when LOAD_ACCOUNT_COMMAND then States::LoadAccount.new(context)
    else menu_state(command, context)
    end
  end

  private

  def menu_state(command, context)
    return States::DeleteAccount.new(context) if command == DELETE_ACCOUNT_COMMAND

    card_state(command, context)
  end

  def card_state(command, context)
    case command
    when SHOW_CARDS_COMMAND then States::ShowCards.new(context)
    when CREATE_CARD_COMMAND then States::CreateCard.new(context)
    when DELETE_CARD_COMMAND then States::DeleteCard.new(context)
    else money_operations_state(command, context)
    end
  end

  def money_operations_state(command, context)
    case command
    when PUT_MONEY_COMMAND then States::PutMoney.new(context)
    when WITHDRAW_MONEY_COMMAND then States::WithdrawMoney.new(context)
    when SEND_MONEY_COMMAND then States::SendMoney.new(context)
    else raise ExitError
    end
  end
end
