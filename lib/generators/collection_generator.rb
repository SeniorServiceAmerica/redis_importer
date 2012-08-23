class CollectionGenerator < Rails::Generators::Base
  source_root File.expand_path("../../templates", __FILE__)  
  argument :collection_type, :type => :string, :default => "s3"

  def generate_collection
    collection_basename = "#{collection_type.downcase}_collection"
    if File.exists?("#{collection_basename}.example.yml")
      copy_file "#{collection_basename}.example.yml", "config/#{collection_basename}.yml"
    end
  end
end