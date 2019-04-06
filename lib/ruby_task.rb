require 'standalone_migrations'

configuration = YAML.safe_load(IO.read('db/config.yml'))
ActiveRecord::Base.establish_connection(configuration[ENV['RAILS_ENV']])

