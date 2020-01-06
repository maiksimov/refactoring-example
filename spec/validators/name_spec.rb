RSpec.describe Validators::Name do
  let(:correct_name) { 'John' }
  let(:wrong_name) { 'lol' }

  describe 'when right name' do
    let(:current_subject) { described_class.new(correct_name) }

    it do
      expect(current_subject.validate?).to eq(true)
    end
  end

  describe 'when wrong name' do
    let(:current_subject) { described_class.new(wrong_name) }

    it do
      expect(current_subject.validate?).to eq(false)
    end
  end
end
