#install packages required by github dependencies
['libmysqlclient-dev', 'cmake', 'libffi-dev'].each {|pckg| package pckg}

execute "personel_git_token" do
  command "perl -pi -e 's/\\+ssh:\\/\\/git\\@github.com/\\+https:\\/\\/#{node[:deploy][:tix][:environment_variables][:git_personal_access_token]}\\@github.com/' #{node[:deploy][:tix][:deploy_to]}/current/tix/environment/dependencies_from_github.txt"
  not_if "grep #{node[:deploy][:tix][:environment_variables][:git_personal_access_token]} #{node[:deploy][:tix][:deploy_to]}/current/tix/environment/dependencies_from_github.txt"
end

execute "install github dependencies" do
  environment(node[:deploy][:tix][:environment])
  user node[:opsworks][:deploy_user][:user]
  command "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv/bin/pip install --exists-action=w -r #{node[:deploy][:tix][:deploy_to]}/current/tix/environment/dependencies_from_github.txt"
end

#version before 
# execute "install github dependencies" do
#     user ode[:opsworks][:deploy_user][:user]
#     environment(
#       'PATH' => "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv/bin:#{ENV['PATH']}", 
#       'VIRTUAL_ENV ' => "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv",
#       'HOME' => "/home/#{deploy[:user]}"
#       )
#     command "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv/bin/pip install --exists-action=w -r #{node[:deploy][:tix][:deploy_to]}/current/tix/environment/dependencies_from_github.txt"
# end
