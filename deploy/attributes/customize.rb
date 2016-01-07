normal[:deploy][:tix][:deploy_to] = '/tix'
normal[:deploy][:tix][:keep_releases] = 2
normal[:opsworks][:deploy_user][:user] = 'deploy'
normal[:opsworks][:deploy_user][:group] = 'deploy'


# the $HOME of the deploy user can be overwritten with this variable.
default[:opsworks][:deploy_user][:home] = '/home/deploy'
node[:deploy].each do |application, deploy|
  default[:deploy][application][:environment] = {
    'PATH' => "#{node[:deploy][:tix][:deploy_to]}/current:#{node[:deploy][:tix][:deploy_to]}/current/virtualenv/bin:#{ENV['PATH']}", 
    'VIRTUAL_ENV ' => "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv"
    #,"HOME" => node[:deploy][application][:home]
  }
end