class S3Collection
  include GemConfigurator
  
  attr_accessor :files

  # Instantiates and configures a S3Collection, using the s3_collection.yml configuration file.
  def initialize
    configure
    connection = AWS::S3::Base.establish_connection! eval(@settings['connection'])
    Bucket.create(eval(@settings['bucket']))
    self.files = Bucket.find(eval(@settings['bucket']))
  end
end