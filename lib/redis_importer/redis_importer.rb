module RedisImporter
  class RedisImporter
    include GemConfigurator

    attr_reader :files, :commands, :errors
    attr_accessor :collection

    def initialize
      configure
      self.collection = Object::const_get("#{@settings[:storage_method].camelcase}Collection").new()
      
      self.files = self.collection.files
      self.commands = []
    end
    
    def import
      files.each do |file|
        begin
          convert_to_redis_commands(file) if class_exists?(file.to_class_name.to_sym)
        rescue NameError
          add_errors("#{file.name} is not matched by a class #{file.to_class_name} in the system.")
        end
      end
      pipeline
    end
    
    private

    attr_writer :files, :commands

    def add_errors(errors)
      @errors ||= []
      @errors << errors
    end

    def class_exists?(c)
      Module.const_get(c)
    end

    def convert_to_redis_commands(file)
      local_path = local_storage_path(file)
      file.save_to(local_path)
      convert_objects_to_redis_commands(get_objects(local_path))
    end

    def default_settings
      {:storage_method => 's3', :local_storage_directory => 'tmp'}
    end

    def get_objects(local_path)
      CsvToObject::CsvToObject.new(local_path).to_objects
    end
    
    def convert_objects_to_redis_commands(objects)
      objects.each do |obj|
        self.commands << obj.to_redis
      end
    end
    
    def local_storage_path(file)
      "#{@settings[:local_storage_directory]}/#{file.name}"
    end

    def pipeline
      if !self.commands.empty?
        pipeline = RedisPipeline::RedisPipeline.new
        pipeline.add_commands(self.commands.flatten)
        if !pipeline.execute_commands
          add_errors(pipeline.errors)
          false
        else
          true
        end
      else
        self.commands
      end
    end
  end
end