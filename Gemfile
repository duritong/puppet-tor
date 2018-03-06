# vim:ft=ruby
source 'https://rubygems.org'

gem 'rake'
# 5.3.4 is currently broken
# https://github.com/rodjek/rspec-puppet/issues/647
gem 'puppet', ENV['PUPPET_VERSION'] || '< 5.3.4'

gem 'base32'

group :tests do
  gem 'facter', ENV['FACTER_VERSION']
  gem 'hiera', ENV['HIERA_VERSION']
  gem 'puppetlabs_spec_helper'
  gem 'librarian-puppet'
  gem 'metadata-json-lint'
  gem 'semantic_puppet'
end
