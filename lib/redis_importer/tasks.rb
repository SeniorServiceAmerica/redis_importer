require 'redis_importer'

if defined?(Rails) && File.exists?(Rails.root.join("config/initializers", "local.rb"))
  require Rails.root.join("config/initializers", "local.rb")
end

namespace :redis_importer do
  desc 'Run import'
  task 'import' => :environment do
    ri = RedisImporter::RedisImporter.new
    ri.import
    result = ri.errors
    puts "test: #{result}"
  end
end