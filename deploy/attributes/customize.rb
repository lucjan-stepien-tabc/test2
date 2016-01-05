normal[:deploy][:tix][:deploy_to] = '/tix'
normal[:deploy][:tix][:keep_releases] = 2
normal[:opsworks][:deploy_user][:shell] = '/bin/bash'
normal[:opsworks][:deploy_user][:user] = 'deploy'

# The deploy provider used. Set to one of
# - "Branch"      - enables deploy_branch (Chef::Provider::Deploy::Branch)
# - "Revision"    - enables deploy_revision (Chef::Provider::Deploy::Revision)
# - "Timestamped" - enables deploy (default, Chef::Provider::Deploy::Timestamped)
# Deploy provider can also be set at application level.
default[:opsworks][:deploy_chef_provider] = 'Timestamped'

valid_deploy_chef_providers = ['Timestamped', 'Revision', 'Branch']
unless valid_deploy_chef_providers.include?(node[:opsworks][:deploy_chef_provider])
  raise "Invalid deploy_chef_provider: #{node[:opsworks][:deploy_chef_provider]}. Valid providers: #{valid_deploy_chef_providers.join(', ')}."
end

# the $HOME of the deploy user can be overwritten with this variable.
#default[:opsworks][:deploy_user][:home] = '/home/deploy'
default[:deploy][application][:environment] = {
	'PATH' => "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv/bin:#{ENV['PATH']}", 
    'VIRTUAL_ENV ' => "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv",
    "HOME" => node[:deploy][application][:home]
}

 
