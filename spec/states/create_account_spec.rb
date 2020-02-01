RSpec.describe States::CreateAccount do
  let(:context) { instance_double('Context', accounts: []) }
  let(:state) { described_class.new(context) }
  let(:name) { 'John Doe' }
  let(:login) { 'johndoe' }
  let(:password) { '123456' }
  let(:age) { '32' }
  let(:current_account) { instance_double('Account', name: name, login: login, password: password, age: age) }

  describe 'when action' do
    before do

      allow(state).to receive_messages(name_input: name, login_input: login, password_input: password, age_input: age)
      allow(context).to receive(:current_account=).and_return(current_account)
      allow(context).to receive(:current_account).and_return(current_account)
      allow(context).to receive(:save)
      state.instance_variable_set(:@context, context)
    end

    context 'without errors' do
      before do
        allow(current_account).to receive(:validated?).and_return(true)
      end

      it 'has received save' do
        state.action
        expect(context).to have_received(:save)
      end
    end

    context 'with errors' do
      let(:errors) { ['error message'] }

      before do
        allow(current_account).to receive(:validated?).and_return(false)
        allow(current_account).to receive(:errors).and_return(errors)
      end

      it 'has received errors' do
        state.action
      end
    end
  end

  describe 'next' do
    before do
      allow(context).to receive(:current_account).and_return(current_account)
      state.instance_variable_set(:@context, context)
    end

    context 'when return AccountMenu state' do
      before do
        allow(current_account).to receive(:validated?).and_return(true)
      end

      it do
        expect(state.next).to be_a(States::AccountMenu)
      end
    end

    context 'when next_state CreateAccount state' do
      it 'has received errors' do
        state.instance_variable_set(:@next_state, States::CreateAccount::CREATE_ACCOUNT_STATE)
        expect(state.next).to be_a(described_class)
      end
    end
  end
end
