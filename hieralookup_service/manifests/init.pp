#
# This module installs the hiera lookup service
# as a standalone app.
#
class hieralookup_service ($port = '8801', $deploy_dir = '/opt/hieralookup') {
  # install gem
  package { 'sinatra':
    ensure   => present,
    provider => 'gem'
  } ->
  file { 'deploy_dir':
    ensure => 'directory',
    path   => $deploy_dir,
  } ->
  file { 'deploy_lookup_service':
    ensure => 'present',
    path   => "${deploy_dir}/hieralookup.rb",
    mode   => '0755',
    source => 'puppet:///modules/hieralookup_service/link_to_hieralookup.rb'
  } ->
  file { 'startup_script':
    ensure  => 'present',
    path    => '/etc/init.d/hieralookup-service',
    mode    => '0755',
    content => template('hieralookup_service/initd_script.erb')
  } ->
  service { 'hieralookup-service':
    ensure     => 'running',
    enable     => true,
    hasrestart => true
  }
}
