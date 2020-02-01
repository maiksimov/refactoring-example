RSpec.describe Validators::Password do
  let(:empty_password) { '' }
  let(:short_password) { '123' }
  let(:long_password) { '00000111112222233333444445555566666' }
  let(:correct_password) { '123456' }

  describe 'when empty password' do
    let(:current_subject) { described_class.new(empty_password) }

    it do
      expect(current_subject.valid?).to eq(false)
    end
  end

  describe 'when short password' do
    let(:current_subject) { described_class.new(short_password) }

    it do
      expect(current_subject.valid?).to eq(false)
    end
  end

  describe 'when long password' do
    let(:current_subject) { described_class.new(long_password) }

    it do
      expect(current_subject.valid?).to eq(false)
    end
  end

  describe 'when correct password' do
    let(:current_subject) { described_class.new(correct_password) }

    it do
      expect(current_subject.valid?).to eq(true)
    end
  end
end
