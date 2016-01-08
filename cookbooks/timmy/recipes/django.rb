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
  Chef::Log.info("application_home: #{node[:deploy][application][:home]}")
  Chef::Log.info("application_document_root: #{node[:deploy][application][:document_root]}")
  Chef::Log.info("application_absolute_document_root: #{node[:deploy][application][:absolute_document_root]}")
  Chef::Log.info("application_environment: #{node[:deploy][application][:environment]}")
  Chef::Log.info("application_tix_environment: #{node[:deploy][:tix][:environment]}")

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

  python_virtualenv_path = "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv"
  python_virtualenv python_virtualenv_path do
    owner node[:opsworks][:deploy_user][:user]
    group node[:opsworks][:deploy_user][:group]
    action :create
  end
  tix_pth = "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv}"
  
  # file "#{}" do
  #   content '<html>This is a placeholder for the home page.</html>'
  #   mode '0755'
  #   owner 'web_admin'
  #   group 'web_admin'
  # end

end
 include_recipe "timmy::dep_from_github"
# include_recipe "timmy::dbmigrations"
