#
# Cookbook:: elastic_repo_test
# Recipe:: v6
#

beats_version = '6.6.1'
es_version = '6.6.1'

elastic_repo_options = {
  'version' => beats_version,
  'description' => 'Elastic Packages Repository Custom',
  'gpg_key' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
  'yum_baseurl' => 'https://artifacts.elastic.co/packages/6.x/yum',
  'yum_gpgcheck' => true,
  'yum_enabled' => true,
  'yum_priority' => '20',
  'yum_metadata_expire' => '1h',
  'apt_uri' => nil,
  'apt_components' => %w[stable main],
  'apt_distribution' => ''
}

elastic_repo 'default' do
  version elastic_repo_options['version']
  action :delete
end

elastic_repo 'default' do
  elastic_repo_options.each do |key, value|
    send(key, value) unless value.nil?
  end
end

case node['platform_family']
when 'debian'
  package %w[apt-utils openjdk-8-jdk]
when 'fedora'
  package 'fedora-release'
  package %w[java-1.8.0-openjdk]
when 'rhel'
  package 'epel-release'
  package %w[java-1.8.0-openjdk]
end

beats_package_version = %w[fedora rhel amazon].include?(node['platform_family']) ? "#{beats_version}-1" : beats_version
es_package_version = %w[fedora rhel amazon].include?(node['platform_family']) ? "#{es_version}-1" : es_version

%w[filebeat packetbeat metricbeat heartbeat-elastic auditbeat].each do |p|
  package p do
    version beats_package_version
  end
end

%w[elasticsearch kibana].each do |p|
  package p do
    version es_package_version
  end
end
