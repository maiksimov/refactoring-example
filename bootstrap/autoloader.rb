require 'yaml'
# require 'pry'
require 'i18n'
require_relative '../entities/account'
require_relative '../entities/card'
require_relative '../entities/console'
require_relative '../entities/tax'
require_relative '../entities/withdraw_tax'
require_relative '../entities/put_tax'
require_relative '../entities/sender_tax'
require_relative '../errors/exit_error'
require_relative '../states/state'
require_relative '../states/wrong_command'
require_relative '../states/initial'
require_relative '../states/create_account'
require_relative '../states/load_account'
require_relative '../states/account_menu'
require_relative '../states/show_cards'
require_relative '../states/create_card'
require_relative '../context'
require_relative '../state_factory'

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
I18n.default_locale = :en
