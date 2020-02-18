lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rake'

Gem::Specification.new do |s|
  s.name = 'gloac'
  s.version = '0.1'
  s.summary = 'GitLab on AWS Cloud'
  s.description = ''
  s.authors = ['Nikola Tosic']
  s.files = FileList['templates/*.*', 'lib/**/*.rb', 'bin/*', 'README.md']
  s.homepage = 'https://github.com/toshke/gloac'
  s.license = 'MIT'
  s.executables << 'gloac'
  s.add_runtime_dependency 'thor', '~>0.20', '<1'
  s.add_runtime_dependency 'aws-sdk-cloudformation', '~> 1', '<2'
  s.add_runtime_dependency 'cfhighlander'
end
