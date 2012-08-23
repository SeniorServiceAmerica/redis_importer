module RedisImporter
  class RedisImporter
    include GemConfigurator

    attr_reader :files

    attr_accessor :collection

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
    
    def default_settings
      {:storage_method => 's3'}
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
  end
end