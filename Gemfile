source "https://rubygems.org"

gem 'dotenv-rails', groups: [:development, :test]
gem "fastlane"
gem 'xcode-install'
gem 'arkana'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
