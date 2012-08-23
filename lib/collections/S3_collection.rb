class S3Collection
  def initialize
    @credentials = YAML.load_file(File.open('config/s3_credentials.yml'))['development']
    @connection = AWS::S3::Base.establish_connection! @credentials['connection']

    bucket_name = @credentials['bucket']
    Bucket.create(bucket_name)
    @bucket = Bucket.find(bucket_name)
  end
  
  def files
    @bucket
  end
end