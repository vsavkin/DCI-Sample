require 'unit_spec_helper'
require 'active_record'
require 'virtus'
require 'database_cleaner_config'

db_yml_file = File.expand_path('config/database.yml')
db_config = YAML.load_file(db_yml_file)
ActiveRecord::Base.establish_connection(db_config['test'])