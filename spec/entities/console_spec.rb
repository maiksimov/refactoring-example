RSpec.describe Entities::Console do
  ASK_PHRASES = {
    name: 'Enter your name',
    login: 'Enter your login',
    password: 'Enter your password',
    age: 'Enter your age'
  }.freeze

  subject(:console) { current_subject.run }

  let(:current_subject) { described_class.new }

  before do
    allow(STDIN).to receive_message_chain(:gets, :chomp).and_return(*input)
  end

  context 'when input' do
    let(:input) { %w[create exit] }

    it 'is create' do
      expect { console }.to output(/#{ASK_PHRASES[:name]}/).to_stdout
    end
  end
end
