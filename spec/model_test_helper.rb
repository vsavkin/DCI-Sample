require 'unit_test'
require 'active_record'
require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

database_yml = YAML.load_file(File.expand_path('config/database.yml'))
ActiveRecord::Base.establish_connection(database_yml['test'])
