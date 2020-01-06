RSpec.describe States::LoadAccount do
  let(:no_accounts) { 'There is no active accounts' }
  let(:wrong_credentials) { 'There is no account' }
  let(:login_question) { 'Enter your login' }
  let(:agree) { 'y' }
  let(:disagree) { 'n' }
  let(:state) { described_class.new(context) }
  let(:name) { 'John Doe' }
  let(:login) { 'johndoe' }
  let(:password) { '123456' }
  let(:wrong_password) { '1234567' }
  let(:age) { '32' }
  let(:account) { instance_double('Account', name: name, login: login, password: password, age: age, card: []) }
  let(:context) { instance_double('Context', accounts: []) }
  let(:accounts) { [account] }

  describe 'next' do
    context 'when return create account state' do
      it do
        state.instance_variable_set(:@answer, agree)
        expect(state.next).to be_a(States::CreateAccount)
      end
    end

    context 'when return initial state' do
      it do
        expect(state.next).to be_a(States::Initial)
      end
    end

    context 'when return menu state' do
      before do
        allow(context).to receive(:accounts).and_return(accounts)
      end

      it do
        expect(state.next).to be_a(States::AccountMenu)
      end
    end
  end

  describe 'action' do
    context 'without accounts' do
      before do
        allow(state).to receive(:read_input).and_return(agree)
      end

      it do
        expect { state.action }.to output(/#{no_accounts}/).to_stdout
      end
    end

    context 'with accounts' do
      before do
        allow(context).to receive(:current_account)
        allow(context).to receive(:current_account=).and_return(account)
        allow(context).to receive(:accounts).and_return(accounts)
        allow(state).to receive(:read_input).and_return(login, password)
      end

      it do
        expect { state.action }.to output(/#{login_question}/).to_stdout
      end
    end

    context 'with accounts, wrong credentials' do
      before do
        allow(context).to receive(:current_account)
        allow(context).to receive(:current_account=).and_return(account)
        allow(context).to receive(:accounts).and_return(accounts)
        allow(state).to receive(:read_input).and_return(login, wrong_password)
      end

      it do
        expect { state.action }.to output(/#{wrong_credentials}/).to_stdout
      end
    end
  end
end
