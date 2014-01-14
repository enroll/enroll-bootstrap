role :app, ENV['ENROLL_HOST']
set :user, "enroll"

default_run_options[:pty] = true