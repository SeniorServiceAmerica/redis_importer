# -*- encoding: utf-8 -*-
require File.expand_path('../lib/redis_importer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ian Whitney", "Davin Lagerroos"]
  gem.email         = ["iwhitney@ssa-i.org", "dlagerroos@ssa-i.org"]
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
  gem.add_development_dependency('redis_backed_model', '~> 1.0')
  gem.add_dependency('gem_configurator', '~> 1.2')
  gem.add_dependency('csv_to_object', '~> 1.0')
  gem.add_dependency('redis_pipeline','~> 1.0')
  gem.add_dependency('aws-s3', '~> 0.6.3')
end
