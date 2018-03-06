require 'rubygems'
# keep for compatibility for now
require 'puppetlabs_spec_helper/rake_tasks'
task :tests do
  # run syntax checks on manifests, templates and hiera data
  # also runs :metadata_lint
  Rake::Task[:validate].invoke

  # runs puppet-lint
  Rake::Task[:lint].invoke
end

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
