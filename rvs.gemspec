require 'rake'

Gem::Specification.new do |s|
  s.name = 'rvs'
  s.version = '0.1.1'
  s.summary = 'Ruby Values Serialization to ascii text'
  s.description = 'serialization of common ruby value classes to ascii text'
  s.require_path = 'lib'
  s.required_ruby_version = '>= 1.9.2'
  s.add_development_dependency 'dohtest', '>= 0.1.4'
  s.authors = ['Makani Mason', 'Kem Mason']
  s.homepage = 'https://github.com/atpsoft/rvs'
  s.license = 'MIT'
  s.email = ['devinfo@atpsoft.com']
  s.extra_rdoc_files = ['MIT-LICENSE']
  s.test_files = FileList["{test}/**/*.rb"].to_a
  s.files = FileList["{lib,test}/**/*"].to_a
end
