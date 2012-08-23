module RedisImporter
  class RedisImporter

    attr_reader :settings, :files

    attr_accessor :collection

    DEFAULT_SETTINGS = {:storage_method => 's3'}

    def initialize
      configure
      self.collection = S3Collection.new
      
      self.files = self.collection.files
    end
    
    def import
      files.each do |file|
        if class_exists?(file.to_class_name)
          self.local_path = "tmp/#{file.name}"
          file.save_to(local_path)
          get_redis_commands
        end
      end
      pipeline
    end
    
    private

    attr_writer :files
    attr_accessor :local_path

    def class_exists?(c)
      Object::const_defined?(c)
    end

    def get_objects
      CsvToObject::CsvToObject.new(local_path).to_objects
    end
    
    def get_redis_commands
      @commands ||= []
      get_objects.each do |obj|
        @commands << obj.to_redis
      end
    end
    
    def pipeline
      if @commands && !@commands.empty?
        pipeline = RedisPipeline::RedisPipeline.new
        pipeline.add_commands(@commands.flatten)
        pipeline.execute_commands
      end
    end
    
    
    # Extract the below to a generic configuration module
      # Module will need to include active_support/inflector
    def config_path
      config_file_name = "#{self.class.to_s.underscore}.yml"
      if defined?(Rails) && File.exists?(Rails.root.join("config",config_file_name))
        Rails.root.join("config",config_file_name)
      else
        nil
      end
    end
    
    def configure
      raw_settings = parse_yaml(config_path())

      if raw_settings
        @settings = raw_settings[Rails.env]
      else
        @settings = {}          
      end

      @settings = DEFAULT_SETTINGS.merge(@settings)
    end

    def parse_yaml(path)
      path ? YAML.load_file(path) : nil
    end
    # End configuration module
  end
end