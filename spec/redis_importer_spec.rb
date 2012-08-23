require "spec_helper"
require_relative '../test/lib/person.rb'

describe RedisImporter do
  before(:all) do
    credentials = YAML.load_file(File.open('config/s3_credentials.yml'))['development']
    connection = AWS::S3::Base.establish_connection! credentials['connection']
  
    bucket_name = credentials['bucket']
    Bucket.create(bucket_name)
    bucket = Bucket.find(bucket_name)
  
    test_csv_files = Dir.glob("test/csv/*.csv")
    test_class_names = test_csv_files.map {|f| File.basename(f).gsub('.csv','').capitalize}
  
    test_csv_files.each do |file_path|
      filename = File.basename(file_path)
      file = File.open(file_path)
      S3Object.store(filename,file,bucket_name)
    end
  end

  before(:each) do
    @ri = RedisImporter::RedisImporter.new
  end

  it "determines its file storage type from a configuration file" do
    @ri.settings[:storage_method].should == 's3'
  end
  
  it "uses its storage method to get a file collection module" do
    @ri.collection.class.to_s.should == 'S3Collection'
  end

  it "checks to see if each file is matched by a class in the system" do 
    @ri.should_receive(:class_exists?).twice
    @ri.import
  end
  
  it "only passes files to csv_to_object that are matched by a class in the system" do
    @ri.should_receive(:get_redis_commands).once
    @ri.import
  end
  
  it "passes the redis commands to the redis pipeline" do
    @ri.should_receive(:pipeline)
    @ri.import
  end
  
  it "reports the success of import" do
    @ri.import.should == true
  end
end