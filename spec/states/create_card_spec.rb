RSpec.describe States::CreateCard do
  USUAL_CARD = 'usual'.freeze
  CAPITALIST_CARD = 'capitalist'.freeze
  VIRTUAL_CARD = 'virtual'.freeze

  let(:state) { described_class.new(context) }
  let(:name) { 'John Doe' }
  let(:login) { 'johndoe' }
  let(:password) { '123456' }
  let(:age) { '32' }
  let(:current_account) { instance_double('Account', name: name, login: login, password: password, age: age, card: []) }
  let(:context) { instance_double('Context') }

  describe 'next' do
    context 'wrong card' do
      before do
        state.instance_variable_set(:@wrong_card, true)
      end

      it { expect(state.next).to be_a(described_class)}
    end

    context ' card' do
      before do
        state.instance_variable_set(:@wrong_card, nil)
      end

      it { expect(state.next).to be_a(States::AccountMenu)}
    end
  end

  describe 'action' do
    before do
      allow(state).to receive(:read_input).and_return(USUAL_CARD)
      allow(context).to receive(:current_account).and_return(current_account)
      allow(context).to receive(:save)
      state.instance_variable_set(:@context, context)
    end

    it 'has save' do
      state.action
      expect(context).to have_received(:save)
    end

    context 'has usual card' do
      before do
        allow(state).to receive(:read_input).and_return(USUAL_CARD)
      end

      it do
        state.action
        expect(current_account.card.pop.type).to eq(USUAL_CARD)
      end
    end

    context 'has capitalist card' do
      before do
        allow(state).to receive(:read_input).and_return(CAPITALIST_CARD)
      end

      it do
        state.action
        expect(current_account.card.pop.type).to eq(CAPITALIST_CARD)
      end
    end

    context 'has virtual card' do
      before do
        allow(state).to receive(:read_input).and_return(VIRTUAL_CARD)
      end

      it do
        state.action
        expect(current_account.card.pop.type).to eq(VIRTUAL_CARD)
      end
    end

    context 'wrong card' do
      let(:wrong_card) { 'wrong' }
      before do
        allow(state).to receive(:read_input).and_return(wrong_card)
      end

      it do
        expect(state.action).to eq(true)
      end
    end
  end
end
