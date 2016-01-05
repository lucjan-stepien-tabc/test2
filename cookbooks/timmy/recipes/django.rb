include_recipe "deploy"
include_recipe "python"

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'other'
    Chef::Log.debug("Skipping deploy::django application #{application} as it is not a Django app")
    next
  end
  Chef::Log.info("personal_access: #{node[:deploy][:tix][:environment_variables][:git_personal_access_token]}")
  Chef::Log.info("database_host: #{node[:deploy][:tix][:database][:host]}")
  Chef::Log.info("database_username: #{node[:deploy][:tix][:database][:username]}")
  Chef::Log.info("database_database: #{node[:deploy][:tix][:database][:database]}")
  Chef::Log.info("deploy_user: #{deploy[:user]}")
  Chef::Log.info("deploy_user: #{node[:opsworks][:deploy_user][:user]}")
  
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
  
  user 'tix-wsgi' do
    comment 'WSGI Deamon user for httpd'
    system true
    home '/tix-def/tix-wsgi'
    shell '/bin/false'
  end
  python_virtualenv "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv" do
    owner 'deploy'
    group 'www-data'
    action :create
  end
  include_recipe "timmy::dep_from_github"
  include_recipe "timmy::dbmigrations"
end