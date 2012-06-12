# -*- encoding: utf-8 -*-
require File.expand_path('../lib/finder/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kirill"]
  gem.summary       = %q{Query for values from file}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "finder"
  gem.require_paths = ["lib"]
  gem.version       = Finder::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_dependency 'xml-simple'
  gem.add_dependency 'rest-client'
  gem.add_dependency 'sinatra'
  gem.add_dependency 'thin'
end
