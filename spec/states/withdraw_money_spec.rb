RSpec.describe States::WithdrawMoney do
  let(:no_active_cards) { 'There is no active cards' }
  let(:wrong_card_index) { 'Choose correct card' }
  let(:no_sender_money_message) { 'no enough money on sender card' }
  let(:no_money_message) { 't have enough money on card' }
  let(:wrong_card_number_message) { 'input correct number' }
  let(:correct_amount_message) { 'You must input correct amount' }
  let(:wrong_tax_message) { 'Your tax is higher than input amount' }
  let(:no_card_message) { 'no card with number' }
  let(:wrong_number_message) { 'You entered wrong number' }
  let(:login_question) { 'Enter your login' }
  let(:wrong_amount) { '0' }
  let(:not_exist_card_number) { '1111222233334444' }
  let(:wrong_card_number) { '123456' }
  let(:amount) { '100' }
  let(:big_amount) { '1000' }
  let(:disagree) { 'n' }
  let(:state) { described_class.new(context) }
  let(:name) { 'John Doe' }
  let(:login) { 'johndoe' }
  let(:password) { '123456' }
  let(:wrong_password) { '1234567' }
  let(:age) { '32' }
  let(:current_account) { instance_double('Account', name: name, login: login, password: password, age: age, card: []) }
  let(:context) { instance_double('Context', accounts: []) }
  let(:card_number) { '1234567812345678' }
  let(:card_type) { 'usual' }
  let(:card_index) { 1 }
  let(:wrong_index) { 123 }
  let(:card) { instance_double('Card', number: card_number, type: card_type, balance: 0) }
  let(:cards) { [card] }
  let(:right_tax) { 1 }

  describe 'next' do
    context 'when return menu state' do
      it do
        expect(state.next).to be_a(States::AccountMenu)
      end
    end
  end

  describe 'action' do
    context 'without active cards' do
      before do
        allow(context).to receive(:current_account).and_return(current_account)
      end

      it do
        expect { state.action }.to output(/#{no_active_cards}/).to_stdout
      end
    end

    context 'with active cards, wrong card index' do
      before do
        allow(current_account).to receive(:card).and_return(cards)
        allow(context).to receive(:current_account).and_return(current_account)
        allow(state).to receive(:read_input).and_return(wrong_index)
      end

      it do
        expect { state.action }.to output(/#{I18n.t('choose_correct_card')}/).to_stdout
      end
    end

    context 'with active cards, wrong number' do
      before do
        allow(current_account).to receive(:card).and_return(cards)
        allow(context).to receive(:current_account).and_return(current_account)
        allow(state).to receive(:read_input).and_return(card_index, wrong_amount)
      end

      it do
        expect { state.action }.to output(/#{correct_amount_message}/).to_stdout
      end
    end

    context 'with active cards, wrong number' do
      before do
        allow(current_account).to receive(:card).and_return(cards)
        allow(context).to receive(:current_account).and_return(current_account)
        allow(state).to receive(:read_input).and_return(card_index, amount)
      end

      it do
        expect { state.action }.to output(/#{no_money_message}/).to_stdout
      end
    end

    context 'when all right' do
      before do
        allow(card).to receive(:balance).and_return(big_amount.to_i)
        allow(current_account).to receive(:card).and_return(cards)
        allow(context).to receive(:current_account).and_return(current_account)
        allow(state).to receive(:read_input).and_return(card_index, amount)
        allow(state).to receive(:withdraw_tax).and_return(0)
        allow(context).to receive(:save)
        allow(card).to receive(:balance=)
      end

      it do
        state.action
        expect(context).to have_received(:save)
      end
    end
  end
end
