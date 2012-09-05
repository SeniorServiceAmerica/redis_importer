# RedisImporter

Takes csv files stored on Amazon S3, converts them to objects and then imports those objects into redis, serialized as redis hashes. This gem is the glue between several other gems:

* `csv_to_object` (handles the conversion of a csv file to objects)
* `redis_backed_model` (Gives an object a to_redis command that serializes an object as a series of redis commands)
* `redis_pipeline` (Imports large sets of commands into a redis instance)

If you have those other gems set up correctly, then RedisImporter is straightforward. Tell it where your csv files are stored and you're good to go.

## Installation

Add this line to your application's Gemfile:

    gem 'redis_importer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis_importer
    
## Configuration

    rails g redis_importer:install
    
1. Edit config/redis_importer.yml to set your remote file-storage method and what directory should store local copies of the files during import.
2. Edit config/s3_collection.yml to set your access key, secret access key, bucket name, etc.

**At this time only Amazon S3 is supported as a remote file-storage method.**

## Usage

```ruby
  @ri = RedisImporter::RedisImporter.new
  @ri.import => true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
