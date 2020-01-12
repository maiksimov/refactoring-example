# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'i18n'
gem 'rugged'

group :development do
  gem 'fasterer'
  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :test do
  gem 'fasterer'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'rspec', '~> 3.8'
  gem 'simplecov'
  gem 'simplecov-lcov'
  gem 'undercover'
end
