RSpec.describe StateFactory do
  CREATE_ACCOUNT_COMMAND = 'create'.freeze
  LOAD_ACCOUNT_COMMAND = 'load'.freeze
  DELETE_ACCOUNT_COMMAND = 'DA'.freeze
  SHOW_CARDS_COMMAND = 'SC'.freeze
  CREATE_CARD_COMMAND = 'CC'.freeze
  DELETE_CARD_COMMAND = 'DC'.freeze
  PUT_MONEY_COMMAND = 'PM'.freeze
  WITHDRAW_MONEY_COMMAND = 'WM'.freeze
  SEND_MONEY_COMMAND = 'SM'.freeze
  EXIT = 'exit'.freeze

  let(:context) { instance_double('Context') }

  describe 'when factory' do
    it 'return create state' do
      expect(subject.state(CREATE_ACCOUNT_COMMAND, context)).to be_a(States::CreateAccount)
    end

    it 'return load account state' do
      expect(subject.state(LOAD_ACCOUNT_COMMAND, context)).to be_a(States::LoadAccount)
    end

    it 'return delete account state' do
      expect(subject.state(DELETE_ACCOUNT_COMMAND, context)).to be_a(States::DeleteAccount)
    end

    it 'return show cards state' do
      expect(subject.state(SHOW_CARDS_COMMAND, context)).to be_a(States::ShowCards)
    end

    it 'return create card state' do
      expect(subject.state(CREATE_CARD_COMMAND, context)).to be_a(States::CreateCard)
    end

    it 'return delete card state' do
      expect(subject.state(DELETE_CARD_COMMAND, context)).to be_a(States::DeleteCard)
    end

    it 'return put money state' do
      expect(subject.state(PUT_MONEY_COMMAND, context)).to be_a(States::PutMoney)
    end

    it 'return withdraw money state' do
      expect(subject.state(WITHDRAW_MONEY_COMMAND, context)).to be_a(States::WithdrawMoney)
    end

    it 'return send money state' do
      expect(subject.state(SEND_MONEY_COMMAND, context)).to be_a(States::SendMoney)
    end

    it 'exit' do
      expect { subject.state(EXIT, context) }.to raise_error(ExitError)
    end
  end
end
