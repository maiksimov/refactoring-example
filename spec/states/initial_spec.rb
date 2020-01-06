RSpec.describe States::Initial do
  let(:context) { instance_double('Context', load_accounts: []) }
  let(:state) { described_class.new(context) }

  describe 'action' do
    it 'has reseived load accounts' do
      state.action
      expect(context).to have_received(:load_accounts)
    end
  end
end
