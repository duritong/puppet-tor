require 'rubygems'
# keep for compatibility for now
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

# use librarian-puppet to manage fixtures instead of .fixtures.yml
# offers more possibilities like explicit version management, forge downloads,...
task :librarian_spec_prep do
  sh "librarian-puppet install --path=spec/fixtures/modules/"
  pwd = `pwd`.strip
  unless File.directory?("#{pwd}/spec/fixtures/modules/tor")
    sh "ln -s #{pwd} #{pwd}/spec/fixtures/modules/tor"
  end
end
task :spec_prep => :librarian_spec_prep
