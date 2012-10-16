module RedisImporter
  class RedisImporter
    include GemConfigurator

    attr_reader :files, :commands, :errors
    attr_accessor :collection

    # Instantiates and configures a RedisImporter object
    def initialize
      configure
      self.collection = Object::const_get("#{@settings['storage_method'].camelcase}Collection").new()
      
      self.files = self.collection.files
      self.errors = []
      self.commands = []
      self.run_pipeline = true
    end
    
    # Converts each csv file in the collection to objects, which are then saved into the redis store.
    def import
      files.each do |file|
        save_remote_file_locally(file)
        begin
          convert_to_redis_commands(file) if class_exists?(file.to_class_name.to_sym)
        rescue NameError
          add_errors("#{file.name} is not matched by a class #{file.to_class_name} in the system.")
          add_errors($!)
        end
      end

      pipeline
    end
  
    private

    attr_accessor :run_pipeline
    attr_writer :files, :commands, :errors

    def add_errors(errors)
      self.errors << errors
    end

    def class_exists?(c)
      Module.const_get(c)
    end

    def convert_to_redis_commands(file)
      convert_objects_to_redis_commands(get_objects(local_storage_path(file)))
    end

    def default_settings
      {'storage_method' => 's3', 'local_storage_directory' => 'tmp'}
    end

    def get_objects(local_path)
      CsvToObject::CsvToObject.new(local_path).to_objects
    end
    
    def convert_objects_to_redis_commands(objects)
      objects.each do |obj|
        begin
          self.commands << obj.to_redis
        rescue => details
          self.run_pipeline = false
          add_errors("#{obj.inspect} could not be serialized to redis: " + details.to_s)
        end
      end
    end
    
    def local_storage_path(file)
      "#{@settings['local_storage_directory']}/#{file.name}"
    end
    
    def pipeline
      if run_pipeline?
        pipeline = RedisPipeline::RedisPipeline.new
        pipeline.add_command(self.commands.flatten)
        if !pipeline.execute
          add_errors(pipeline.errors)
          false
        else
          true
        end
      else
        false
      end
    end
    
    def run_pipeline?
      run_pipeline
    end
    
    def save_remote_file_locally(file)
      file.save_to(local_storage_path(file))
    end
  end
end