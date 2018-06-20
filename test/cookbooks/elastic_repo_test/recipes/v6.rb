#
# Cookbook:: elastic_beats_repo_test
# Recipe:: v6
#

elastic_repo 'default' do
  version '6.3.0'
end

package %w[apt-utils openjdk-8-jdk] if node['platform_family'] == 'debian'

%w[filebeat packetbeat metricbeat heartbeat-elastic auditbeat elasticsearch kibana].each do |p|
  package p do
    version %w[fedora rhel amazon].include?(node['platform_family']) ? '6.3.0-1' : '6.3.0'
  end
end
