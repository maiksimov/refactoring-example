RSpec.describe States::CreateAccount do

  let(:context) { instance_double('Context', accounts: []) }
  let(:state) { described_class.new(context) }
  let(:name) { 'John Doe' }
  let(:login) { 'johndoe' }
  let(:password) { '123456' }
  let(:age) { '32' }
  let(:current_account) { instance_double('Account', name: name, login: login, password: password, age: age) }

  describe 'action' do
    before do
      allow(state).to receive(:name_input).and_return(name)
      allow(state).to receive(:login_input).and_return(login)
      allow(state).to receive(:password_input).and_return(password)
      allow(state).to receive(:age_input).and_return(age)
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
        expect(current_account).to have_received(:errors)
      end
    end
  end

  describe 'next' do
    before do
      allow(context).to receive(:current_account).and_return(current_account)
      state.instance_variable_set(:@context, context)
    end

    context 'return create state' do
      before do
        allow(current_account).to receive(:validated?).and_return(true)
      end

      it 'has state' do
        expect(state.next).to be_a(States::AccountMenu)
      end
    end

    context 'return account menu state' do
      before do
        allow(current_account).to receive(:validated?).and_return(false)
      end

      it 'has received errors' do
        expect(state.next).to be_a(States::CreateAccount)
      end
    end
  end
end
