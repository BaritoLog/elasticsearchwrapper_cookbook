# # encoding: utf-8

# Inspec test for recipe elasticsearch::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe group('elasticsearch') do
    it { should exist }
  end

  describe user('elasticsearch')  do
    it { should exist }
  end
end

describe package('openjdk-11-jdk-headless') do
  it { should be_installed }
end

describe directory('/var/lib/elasticsearch') do
  its('mode') { should cmp '0755' }
  its('owner') { should eq 'elasticsearch' }
  its('group') { should eq 'elasticsearch' }
end

describe directory('/var/log/elasticsearch') do
  its('mode') { should cmp '0755' }
  its('owner') { should eq 'elasticsearch' }
  its('group') { should eq 'elasticsearch' }
end

describe systemd_service('elasticsearch') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
