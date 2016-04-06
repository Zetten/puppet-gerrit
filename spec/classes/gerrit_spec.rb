require 'spec_helper'

# Puppet::Util::Log.level = :debug
# Puppet::Util::Log.newdestination(:console)

describe 'gerrit', :type => 'class' do

  context 'with a debian-based node' do
    # Default facts for debian-based node
    let(:facts) {{
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '14.04',

        :lsbdistcodename => 'trusty',
        :lsbdistdescription => 'Ubuntu 14.04.4 LTS',
        :lsbdistid => 'Ubuntu',
        :lsbdistrelease => '14.04',
        :lsbmajdistrelease => '14.04',
    }}
    let(:pre_condition){
    """
    Package {
      provider => 'apt',
    }
    """
    }

    it { should compile }
    it { should contain_class('gerrit') }
  end
end
