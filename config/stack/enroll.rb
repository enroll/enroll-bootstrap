def mkdir_and_chown(path, user)
  runner "mkdir -p #{path}"
  runner "chown #{user} #{path}"
end

package :enroll do
  # Apache virtual host

  user_name = 'enroll'
  app_name = 'enroll'
  environment = ENV['ENROLL_ENV']
  host_name = ENV['ENROLL_HOST']
  app_path = "/var/apps/#{app_name}"
  current_path = "#{app_path}/current"
  shared_path = "#{app_path}/shared"
  public_path = "#{current_path}/public"
  locals = {
    :user_name => user_name,
    :host_name => host_name,
    :host_name_escaped => host_name.gsub('.', '\.'),
    :app_name => app_name,
    :public_path => public_path,
    :environment => environment
  }

  # Remove the default Apache config
  runner "rm -f /etc/apache2/sites-enabled/000-default"

  # Install Apache config for Enroll
  requires :apache
  remote_file = "/etc/apache2/sites-enabled/001-#{app_name}"
  local_template = File.join(File.dirname(__FILE__), app_name, "001-#{app_name}.erb")
  puts "Creating Apache config: #{remote_file}"
  file remote_file,
    :contents => render(local_template, locals),
    :sudo => true do
    post :install, '/etc/init.d/apache2 restart'  
  end

  # Directory structure
  mkdir_and_chown(app_path, user_name)
  mkdir_and_chown(shared_path, user_name)
  mkdir_and_chown("#{shared_path}/config", user_name)
  mkdir_and_chown(current_path, user_name)

  # Create database user
  requires :enroll_db, user_name: user_name, db_name: "#{app_name}_#{environment}"

  # Database config
  db_remote = "#{shared_path}/config/database.yml"
  db_template = File.join(File.dirname(__FILE__), app_name, "database.yml.erb")
  puts "Creating database config: #{db_remote}"
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