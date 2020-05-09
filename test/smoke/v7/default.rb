# # encoding: utf-8

# Inspec test for cookbook elastic_repo lwrp resource

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

if %w(redhat fedora amazon).include?(os[:family])
  describe file('/etc/yum.repos.d/elastic7.repo') do
    its('content') { should match %r{https://artifacts.elastic.co/packages/7.x/yum} }
  end
else
  describe file('/etc/apt/sources.list.d/elastic7.list') do
    its('content') { should match %r{https://artifacts.elastic.co/packages/7.x/apt} }
  end
end

describe package('filebeat') do
  it { should be_installed }
  its('version') { should match '7.6.2' }
end

describe package('packetbeat') do
  it { should be_installed }
  its('version') { should match '7.6.2' }
end

describe package('metricbeat') do
  it { should be_installed }
  its('version') { should match '7.6.2' }
end

describe package('heartbeat-elastic') do
  it { should be_installed }
  its('version') { should match '7.6.2' }
end

describe package('auditbeat') do
  it { should be_installed }
  its('version') { should match '7.6.2' }
end
