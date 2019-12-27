class Context
  attr_accessor :current_account, :accounts, :state, :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def save
    File.open(@file_path, 'w') { |f| f.write @accounts.to_yaml }
  end

  def load_accounts
    @accounts = File.exists?(@file_path) ? YAML.load_file(@file_path) : []
  end
end
