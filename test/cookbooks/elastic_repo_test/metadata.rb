name 'elastic_repo_test'
maintainer 'Virender Khatri'
maintainer_email 'vir.khatri@gmail.com'
license 'Apache-2.0'
description 'Test cookbook elastic_repo'
version '0.1.0'
source_url 'https://github.com/vkhatri/chef-elastic-repo'
issues_url 'https://github.com/vkhatri/chef-elastic-repo/issues'
chef_version '>= 12.14'

%w(debian ubuntu centos amazon redhat fedora).each do |os|
  supports os
end

depends 'elastic_repo'
