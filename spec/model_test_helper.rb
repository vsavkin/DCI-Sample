require 'unit_test'
require 'active_record'

database_yml = YAML.load_file(File.expand_path('config/database.yml'))
ActiveRecord::Base.establish_connection(database_yml['test'])
