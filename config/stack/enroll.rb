package :enroll do
  # Apache virtual host

  user_name = 'enroll'
  app_name = 'enroll'
  host_name = 'test1.enroll.io'
  app_path = "/var/apps/#{app_name}"
  current_path = "#{app_path}/current"
  public_path = "#{current_path}/public"

  # Apache config
  requires :apache
  remote_file = "/etc/apache2/sites-enabled/001-#{app_name}"
  local_template = File.join(File.dirname(__FILE__), app_name, "001-#{app_name}.erb")
  locals = {
    :host_name => host_name,
    :app_name => app_name,
    :public_path => public_path
  }
  file remote_file,
    :contents => render(local_template, locals),
    :sudo => true do
    post :install, '/etc/init.d/apache2 restart'  
  end

  # Directory structure
  runner "mkdir -p #{app_path}"
  runner "chown #{user_name} #{app_path}"

end