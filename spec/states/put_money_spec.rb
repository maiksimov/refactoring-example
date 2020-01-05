RSpec.describe States::PutMoney do

  let(:no_active_cards) { 'There is no active cards' }
  let(:wrong_tax_message) { 'Your tax is higher than input amount' }
  let(:wrong_number) { 'You entered wrong number' }
  let(:login_question) { 'Enter your login' }
  let(:wrong_amount) { '0' }
  let(:amount) { '100' }
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
  let(:card_index) { 1 }
  let(:right_tax) { 1 }

  describe 'next' do
    context 'return menu state' do
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
    context 'with active cards, wrong amount' do
        before do
          allow(current_account).to receive(:card).and_return(cards)
          allow(context).to receive(:current_account).and_return(current_account)
          allow(state).to receive(:read_input).and_return(card_index, wrong_amount)
        end
      it do
        expect { state.action }.to output(/#{card_number}/).to_stdout
      end
    end
    context 'with active cards, wrong number' do
        before do
          allow(current_account).to receive(:card).and_return(cards)
          allow(context).to receive(:current_account).and_return(current_account)
          allow(state).to receive(:read_input).and_return(wrong_index)
        end
      it do
        expect { state.action }.to output(/#{wrong_number}/).to_stdout
      end
    end
    context 'with active cards, wrong tax' do
      before do
        allow(current_account).to receive(:card).and_return(cards)
        allow(context).to receive(:current_account).and_return(current_account)
        allow(state).to receive(:read_input).and_return(card_index, amount)
        allow(state).to receive(:put_tax).and_return(amount.to_i)
      end
      it do
        expect { state.action }.to output(/#{wrong_tax_message}/).to_stdout
      end
    end
    context 'all right' do
      before do
        allow(current_account).to receive(:card).and_return(cards)
        allow(context).to receive(:current_account).and_return(current_account)
        allow(context).to receive(:save)
        allow(state).to receive(:read_input).and_return(card_index, amount)
        allow(state).to receive(:put_tax).and_return(right_tax)
        allow(card).to receive(:balance=)
      end
      it do
        expect { state.action }.to output(/#{card_number}/).to_stdout
      end
    end
  end
end
