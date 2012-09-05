require 'redis_importer/version'

# Requiring unreleased gems
require 'bundler'
Bundler.require

# Requiring released gems defined 
require 'aws/s3'
require 'gem_configurator'
require 'csv_to_object'
require 'redis_pipeline'
include AWS::S3

# Requiring local files
require 'redis_importer/redis_importer'
require 'collections/S3_collection'
require 'extensions/s3'
