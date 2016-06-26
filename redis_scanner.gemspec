# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_scanner/version'

Gem::Specification.new do |spec|
  spec.name          = "redis_scanner"
  spec.version       = RedisScanner::VERSION
  spec.authors       = ["Vincent Xie"]
  spec.email         = ["xiewenwei@gmail.com"]

  spec.summary       = %q{RedisScanner is a tiny tool for scanning redis's keys and creating statistic information.}
  spec.description   = %q{RedisScanner is a tiny tool for scanning redis's keys and creating statistic information. It scans keys using redis scan command and computing statistic result by key's pattern.}
  spec.homepage      = "http://github.com/xiewenwei/redis_scanner.git"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["redis_scanner"]
  spec.require_paths = ["lib"]

  spec.add_dependency "redis"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
