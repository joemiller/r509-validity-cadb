$:.push File.expand_path("../lib", __FILE__)
require "r509/validity/cadb/version"

spec = Gem::Specification.new do |s|
  s.name = 'r509-validity-cadb'
  s.version = R509::Validity::CADB::VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = false
  s.summary = 'A Validity::Checker for r509, implemented with an OpenSSL CA DB loader backend'
  s.description = 'A Validity::Checker for r509, implemented with an OpenSSL CA DB loader backend'
  s.add_dependency 'r509', '>= 0.9.0'
  s.add_dependency 'rufus-scheduler', '~> 3.0'
  s.add_dependency 'rake'
  s.add_dependency 'dependo'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'syntax'
  s.author = 'Joe Miller'
  s.email = 'joeym@joeym.net'
  s.homepage = 'https://joemiller.me'
  s.required_ruby_version = '>= 1.9.3'
  s.files = %w(README.md LICENSE.md Rakefile) + Dir['{lib,spec,doc}/**/*']
  s.test_files= Dir.glob('test/*_spec.rb')
  s.require_path = 'lib'
end

