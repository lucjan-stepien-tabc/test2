normal[:deploy][:tix][:deploy_to] = '/tix'
normal[:deploy][:tix][:keep_releases] = 2
normal[:opsworks][:deploy_user][:user] = 'deploy'
normal[:opsworks][:deploy_user][:group] = 'deploy'

node[:deploy].each do |application, deploy|
  default[:deploy][application][:environment] = {
    'PATH' => "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv/bin:#{ENV['PATH']}",
    'VIRTUAL_ENV ' => "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv"
  }
end
