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
    owner 'tix-wsgi'
    group 'ubuntu'
    action :create
  end

end