require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.hiera_config = 'spec/fixtures/hiera.yaml'
  c.default_facts = {
      :fqdn     => 'testnode.example.com',
      :concat_basedir => '/tmp/puppet-concat'
  }
end