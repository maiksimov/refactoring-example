RSpec.describe Validators::Login do
  let(:empty_login) { '' }
  let(:correct_login) { 'johndoe' }
  let(:exists_login) { 'janedoe' }
  let(:short_login) { 'lol' }
  let(:long_login) { 'lollollollollollollol' }
  let(:account) { instance_double('Account', login: exists_login) }
  let(:accounts) { [account] }
  let(:current_subject) { described_class.new(*login, accounts) }

  describe 'when right login' do
    let(:login) { correct_login }

    it do
      expect(current_subject.valid?).to eq(true)
    end
  end

  describe 'when login empty' do
    let(:login) { empty_login }

    it do
      expect(current_subject.valid?).to eq(false)
    end
  end

  describe 'when login short' do
    let(:login) { short_login }

    it do
      expect(current_subject.valid?).to eq(false)
    end
  end

  describe 'when login long' do
    let(:login) { long_login }

    it do
      expect(current_subject.valid?).to eq(false)
    end
  end

  describe 'when login exists' do
    let(:login) { exists_login }

    it do
      expect(current_subject.valid?).to eq(false)
    end
  end
end
