RSpec.describe States::DeleteAccount do
  let(:agree) { 'y' }
  let(:disagree) { 'n' }
  let(:state) { described_class.new(context) }
  let(:name) { 'John Doe' }
  let(:login) { 'johndoe' }
  let(:password) { '123456' }
  let(:age) { '32' }
  let(:current_account) { instance_double('Account', name: name, login: login, password: password, age: age, card: []) }
  let(:context) { instance_double('Context') }
  let(:accounts) { [current_account] }

  describe 'next' do
    context 'when agree' do
      it do
        state.instance_variable_set(:@answer, agree)
        expect(state.next).to be_a(States::Initial)
      end
    end

    context 'when disagree' do
      it do
        state.instance_variable_set(:@answer, disagree)
        expect(state.next).to be_a(States::AccountMenu)
      end
    end
  end

  describe 'action' do
    before do
      allow(context).to receive(:current_account).and_return(current_account)
      allow(context).to receive(:accounts).and_return(accounts)
      allow(context).to receive(:save)
    end

    context 'when agree' do
      before do
        allow(state).to receive(:read_input).and_return(agree)
      end

      it 'delete current' do
        state.action
        expect(accounts).to eq([])
      end

      it 'call save' do
        state.action
        expect(context).to have_received(:save)
      end
    end
  end
end
