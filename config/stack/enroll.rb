package :enroll do
  # Apache virtual host

  user_name = 'enroll'
  app_name = 'enroll'
  host_name = 'test1.enroll.io'
  app_path = "/var/apps/#{app_name}"
  current_path = "#{app_path}/current"
  shared_path = "#{app_path}/shared"
  public_path = "#{current_path}/public"
  locals = {
    :user_name => user_name,
    :host_name => host_name,
    :app_name => app_name,
    :public_path => public_path
  }

  # Apache config
  requires :apache
  remote_file = "/etc/apache2/sites-enabled/001-#{app_name}"
  local_template = File.join(File.dirname(__FILE__), app_name, "001-#{app_name}.erb")
  file remote_file,
    :contents => render(local_template, locals),
    :sudo => true do
    post :install, '/etc/init.d/apache2 restart'  
  end

  # Directory structure
  runner "mkdir -p #{app_path}"
  runner "chown #{user_name} #{app_path}"

  # Create database user
  requires :enroll_db, user_name: user_name, db_name: "#{app_name}_production"

  # Database config
  db_remote = "#{shared_path}/config/database.yml"
  db_template = File.join(File.dirname(__FILE__), app_name, "database.yml.erb")
  file db_remote,
    :contents => render(db_template, locals)

end

package :enroll_db_user do
  runner "su postgres -c 'createuser #{opts[:user_name]} --createdb --no-superuser --no-createrole'"

  verify do 
    runner %Q(su postgres -c "psql -tAc \\"SELECT 1 FROM pg_roles WHERE rolname='#{opts[:user_name]}'\\" | grep -q 1")
  end
end

package :enroll_db do
  requires :enroll_db_user, user_name: opts[:user_name]

  runner "su postgres -c 'createdb #{opts[:db_name]} -O #{opts[:user_name]}'"

  verify do
    runner %Q(su postgres -c 'psql -lqt | cut -d \\| -f 1 | grep -w #{opts[:db_name]} | wc -l | grep -q 1')
  end
end