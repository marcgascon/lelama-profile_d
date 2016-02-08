#!/usr/bin/ruby
#
# Run several types of tests againsts a puppet repo (module or master
# config).

require 'rubygems'
require 'bundler'
require 'rake'

# default
desc 'Run all tests.'
task :default => ['check:syntax', 'check:lint']

# help
desc 'Show available tasks and exit.'
task :help do
  system('rake -T')
end

namespace :check do
  exclude_paths = ['modules/apt/**/*.pp',
                   'modules/aws/**/*',
                   'modules/stdlib/**/*.pp',
                   'vendor/**/*',
                   'spec/**/*']

  # syntax
  # ======
  desc 'Validate syntax for all manifests.'
  task :syntax do
    successes = []
    failures = []
    puppet_files = Dir.glob('**/*.pp').reject{|f| Dir.glob(exclude_paths).include? f}
    puppet_files.each do |puppet_file|
      puts "Checking syntax for #{puppet_file}"

      # Run syntax checker in subprocess.
      system("puppet parser validate #{puppet_file}")

      # Keep track of the results.
      if $?.success?
        successes << puppet_file
      else
        failures << puppet_file
      end
    end

    # Print the results.
    total_manifests = successes.count + failures.count
    puts "Summary:"
    puts "#{total_manifests} files total."
    puts "#{successes.count} files succeeded."
    puts "#{failures.count} files failed:"
    puts
    failures.each do |filename|
      puts filename
    end

    # Fail the task if any files failed syntax check.
    if failures.count > 0
      fail("#{failures.count} filed failed syntax check.")
    end
  end

  # lint
  # ====
  require 'puppet-lint/tasks/puppet-lint'
  PuppetLint.configuration.ignore_paths = exclude_paths
  PuppetLint.configuration.send("disable_autoloader_layout")
  PuppetLint.configuration.send("disable_80chars")
#  PuppetLint.configuration.send("disable_documentation")
#  PuppetLint.configuration.send("disable_variable_scope")
end