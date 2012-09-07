require 'rails'

module RedisImporter
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'redis_importer/tasks.rb'
    end
  end
end