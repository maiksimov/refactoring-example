RSpec.describe States::AccountMenu do
  let(:user_name) { 'John Doe' }
  let(:current_account) { instance_double('Account', name: user_name) }
  let(:context) { instance_double('Context', current_account: current_account) }
  let(:state) { described_class.new(context) }

  describe 'action' do
    it 'has reseived load accounts' do
      state.instance_variable_set(:@context, context)
      expect { state.action }.to output(/#{user_name}/).to_stdout
    end
  end
end
