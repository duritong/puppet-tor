# vim:ft=ruby
source 'https://rubygems.org'

gem 'rake'
gem 'puppet', ENV['PUPPET_VERSION'] || '>= 6.0'

gem 'base32'

group :tests do
  gem 'facter', ENV['FACTER_VERSION']
  gem 'hiera', ENV['HIERA_VERSION']
  gem 'puppetlabs_spec_helper'
  gem 'librarian-puppet'
  gem 'metadata-json-lint'
  gem 'semantic_puppet'
end
