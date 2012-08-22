# -*- encoding: utf-8 -*-
require File.expand_path('../lib/redis_importer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ian Whitney"]
  gem.email         = ["ian@ianwhitney.com"]
  gem.description   = %q{Creates objects, converts them to Redis commands and executes the redis commands.}
  gem.summary       = %q{Creates objects, converts them to Redis commands and executes the redis commands.}
  gem.homepage      = "https://github.com/SeniorServiceAmerica/redis_importer"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "redis_importer"
  gem.require_paths = ["lib"]
  gem.version       = RedisImporter::VERSION

  gem.add_development_dependency "rspec"
  gem.add_dependency('csv_to_object')
  gem.add_dependency('redis_pipeline')
  gem.add_dependency('aws-s3')
end
