class S3Collection
  def initialize
    configuration = YAML.load_file(File.open('config/s3_config.yml'))['development']
    connection = AWS::S3::Base.establish_connection! configuration['connection']

    bucket_name = configuration['bucket']
    Bucket.create(bucket_name)
    @bucket = Bucket.find(bucket_name)
  end
  
  def files
    @bucket
  end
end