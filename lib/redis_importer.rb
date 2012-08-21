require 'redis_importer/version'
require 'bundler'
Bundler.require
include AWS::S3

S3_CREDENTIALS = YAML.load_file(File.open('config/s3_credentials.yml'))['development']
$connection = AWS::S3::Base.establish_connection! S3_CREDENTIALS['connection']
$redis_uri = 'redis://localhost:6379'

module RedisImporter
  class RedisImporter

    def initialize(file_collection)
      self.files = file_collection
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

    attr_accessor(:files,:local_path)

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
        pipeline = RedisPipeline::RedisPipeline.new($redis_uri)
        pipeline.add_commands(@commands.flatten)
        pipeline.execute_commands
      end
    end
  end
end

module AWS
  module S3
    class S3Object
      
      def name
        self.key
      end

      def to_class_name
        self.key.gsub('.csv','').capitalize
      end

      def save_to(path)
        File.open(path,'w') do |file|
          S3Object.stream(self.key,self.bucket.name) do |chunk|
            file.write chunk
          end
        end
      end
    end
  end
end