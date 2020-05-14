#
# Cookbook:: elastic_repo_test
# Recipe:: v6
#

beats_version = '7.6.2'
# es_version = '7.6.2'

elastic_repo_options = {
  'version' => beats_version,
  'description' => 'Elastic Packages Repository Custom',
  'gpg_key' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
  'yum_baseurl' => 'https://artifacts.elastic.co/packages/7.x/yum',
  'yum_gpgcheck' => true,
  'yum_enabled' => true,
  'yum_priority' => '20',
  'yum_metadata_expire' => '1h',
  'apt_uri' => nil,
  'apt_components' => %w(stable main),
  'apt_distribution' => '',
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

case node['platform']
when 'centos', 'redhat', 'fedora', 'amazon'
  deps_packages = value_for_platform(
    %w(centos redhat) => { 'default' => %w(epel-release) },
    'fedora' => { 'default' => %w() },
    'amazon' => { 'default' => %w(epel-release), '2' => %w() }
  )
when 'ubuntu', 'debian', 'raspbian'
  deps_packages = %w(apt-utils)
end

if node['platform_family'] == 'amazon' && (node['platform_version'] == '2')
  execute 'install amazon extra package epel' do
    command 'amazon-linux-extras install epel -y'
  end
elsif platform?('debian')
  apt_repository "#{node['lsb']['codename']}_backports" do
    uri 'http://http.debian.net/debian'
    distribution "#{node['lsb']['codename']}-backports"
    components ['main']
  end
end

# package 'fedora-release-container' do
#  action :remove
#  only_if { platform_family?('fedora') }
# end

package deps_packages

beats_package_version = %w(amazon rhel fedora).include?(node['platform_family']) ? "#{beats_version}-1" : beats_version
# es_package_version = platform_family?('fedora', 'rhel', 'amazon') ? "#{es_version}-1" : es_version

%w(filebeat packetbeat metricbeat heartbeat-elastic auditbeat).each do |p|
  package p do
    version beats_package_version
  end
end
