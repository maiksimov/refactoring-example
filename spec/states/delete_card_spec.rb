RSpec.describe States::DeleteCard do
  let(:agree) { 'y' }
  let(:disagree) { 'n' }
  let(:state) { described_class.new(context) }
  let(:name) { 'John Doe' }
  let(:login) { 'johndoe' }
  let(:password) { '123456' }
  let(:age) { '32' }
  let(:card_number) { '1234567812345678' }
  let(:card_type) { 'usual' }
  let(:card_index) { 1 }
  let(:wrong_index) { 123 }
  let(:current_account) { instance_double('Account', name: name, login: login, password: password, age: age, card: []) }
  let(:context) { instance_double('Context') }
  let(:cards) { [instance_double('Card', number: card_number, type: card_type)] }

  describe 'next' do
    context 'when card valid' do
      before do
        allow(current_account).to receive(:card).and_return(cards)
        allow(context).to receive(:current_account).and_return(current_account)
      end

      it do
        state.instance_variable_set(:@next_state, States::DeleteCard::MENU_STATE)
        expect(state.next).to be_a(States::AccountMenu)
      end
    end

    context 'when card invalid' do
      before do
        allow(context).to receive(:current_account).and_return(current_account)
      end

      it do
        state.instance_variable_set(:@selected_card_index, card_index)
        expect(state.next).to be_a(described_class)
      end
    end
  end

  describe 'action' do
    before do
      allow(context).to receive(:current_account).and_return(current_account)
    end

    context 'without cards' do
      before do
        allow(state).to receive(:account_have_cards?).and_return(false)
      end

      it do
        expect(state.action).to eq(States::DeleteCard::MENU_STATE)
      end
    end

    context 'with cards right index' do
      before do
        allow(current_account).to receive(:card).and_return(cards)
        allow(state).to receive(:read_input).and_return(card_index, agree)
        allow(context).to receive(:save)
      end

      it do
        expect { state.action }.to output(/#{card_number}/).to_stdout
      end

      it do
        state.action
        expect(current_account.card).to be_empty
      end
    end

    context 'with cards wrong index' do
      before do
        allow(current_account).to receive(:card).and_return(cards)
        allow(state).to receive(:read_input).and_return(wrong_index)
      end

      it do
        expect { state.action }.to output(/#{I18n.t('choose_correct_card')}/).to_stdout
      end
    end
  end
end
