source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :test do
  gem 'rake'
  puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['>= 4.4']
  gem 'puppet', puppetversion
  gem 'facter'
  gem 'puppetlabs_spec_helper'
  gem 'puppet-lint'
  gem 'metadata-json-lint'

  # rspec must be v2 for ruby 1.8.7
  if RUBY_VERSION >= '1.8.7' and RUBY_VERSION < '1.9'
    gem 'rspec', '~> 2.0'
  end
end
