module RedisImporter
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)  
      argument :file_storage_type, :type => :string

      def generate_collection
        copy_file "redis_importer.example.yml", "config/redis_importer.yml"
        file_basename = "#{file_storage_type.downcase}_config"
        copy_file "#{file_basename}.example.yml", "config/#{file_basename}.yml"
      end
    end
  end
end