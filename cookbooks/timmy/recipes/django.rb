include_recipe "deploy"
include_recipe "python"

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'other'
    Chef::Log.debug("Skipping deploy::django application #{application} as it is not a Django app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
  
  python_virtualenv "#{node[:deploy][:tix][:deploy_to]}/current" do
    owner node[:opsworks][:deploy_user][:user]
    group node[:opsworks][:deploy_user][:group]
    action :create
  end

end