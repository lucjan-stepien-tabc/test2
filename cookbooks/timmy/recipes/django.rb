include_recipe "deploy"
include_recipe "python"

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'other'
    Chef::Log.debug("Skipping deploy::django application #{application} as it is not a Django app")
    next
  end
  Chef::Log.info("personal_access: #{node[:deploy][:tix][:environment_variables][:git_personal_access_token]}")

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
  #install packages required by github dependencies
  ['libmysqlclient-dev', 'cmake', 'libffi-dev'].each {|pckg| package pckg}

  
  execute "personel_git_token" do
    command "perl -pi -e 's/\\+ssh:\\/\\/git\\@github.com/\\+https:\\/\\/#{node[:deploy][:tix][:environment_variables][:git_personal_access_token]}\\@github.com/' #{node[:deploy][:tix][:deploy_to]}/current/tix/environment/dependencies_from_github.txt"
    not_if "grep #{node[:deploy][:tix][:environment_variables][:git_personal_access_token]} #{node[:deploy][:tix][:deploy_to]}/current/tix/environment/dependencies_from_github.txt"
  end

  execute "install_github_dependencies" do
    environment(
      'PATH' => "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv/bin:#{ENV['PATH']}", 
      'VIRTUAL_ENV ' => "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv" 
      )
    command "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv/bin/pip install --exists-action=w -r #{node[:deploy][:tix][:deploy_to]}/current/tix/environment/dependencies_from_github.txt"
  end

end