#
# Cookbook:: elastic_repo_test
# Recipe:: v5
#

elastic_repo 'default' do
  version '5.6.9'
end

package %w[apt-utils openjdk-8-jdk] if node['platform_family'] == 'debian'

%w[filebeat packetbeat metricbeat elasticsearch kibana].each do |p|
  package p do
    version %w[fedora rhel amazon].include?(node['platform_family']) ? '5.6.9-1' : '5.6.9'
  end
end
