RSpec.describe Validators::Age do
  let(:correct_age) { 32 }
  let(:wrong_age) { 100 }

  describe 'when right age' do
    let(:current_subject) { described_class.new(correct_age) }

    it do
      expect(current_subject.valid?).to eq(true)
    end
  end

  describe 'when wrong age' do
    let(:current_subject) { described_class.new(wrong_age) }

    it do
      expect(current_subject.valid?).to eq(false)
    end
  end
end
