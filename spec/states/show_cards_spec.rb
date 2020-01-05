RSpec.describe States::ShowCards do

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
  let(:card_index) { 1 }

  describe 'action' do
    before do
      allow(context).to receive(:current_account).and_return(current_account)
    end

    context 'without cards' do
      it do
        expect { state.action }.to output(/#{I18n.t('no_active_cards')}/).to_stdout
      end
    end

    context 'with cards right index' do
      before do
        allow(current_account).to receive(:card).and_return(cards)
      end

      it do
        expect { state.action }.to output(/#{ card_number}/).to_stdout
      end
    end

  end
end
