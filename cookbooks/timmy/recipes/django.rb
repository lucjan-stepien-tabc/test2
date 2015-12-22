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
  packages ['libmysqlclient-dev']

  execute "install dependencies" do
    command "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv/bin/pip install -r #{node[:deploy][:tix][:deploy_to]}/current/tix/environment/dependencies_from_internet.txt"
  end

end