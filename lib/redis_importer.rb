require 'redis_importer/version'

# Requiring released gems defined 
require 'aws/s3'
require 'active_support/inflector'
include AWS::S3

# Requiring unreleased gems
require 'bundler'
Bundler.require

# Requiring local files
require 'redis_importer/redis_importer'
require 'collections/S3_collection'
require 'extensions/s3'
