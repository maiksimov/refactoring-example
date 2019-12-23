require 'yaml'
require 'pry'
require 'i18n'
require_relative '../entities/account'
require_relative '../entities/card'
require_relative '../entities/console'

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
I18n.default_locale = :en
