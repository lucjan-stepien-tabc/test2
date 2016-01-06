execute "migrate tix_database" do
  command "#{node[:deploy][:tix][:deploy_to]}/current/virtualenv/bin/python #{node[:deploy][:tix][:deploy_to]}/current/tix/manage.py migrate"
  environment(node[:deploy][:tix][:environment])
end