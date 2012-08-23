class RedisImporterGenerator < Rails::Generators::Base
  source_root File.expand_path("../../templates", __FILE__)  

  def generate_collection
    copy_file "redis_importer.example.yml", "config/redis_importer.yml"
  end
end