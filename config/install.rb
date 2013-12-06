$:<< File.join(File.dirname(__FILE__), 'stack')

require 'essential'
require 'scm'
require 'ruby'
require 'postgresql'
require 'enroll'
require 'apache'

policy :stack, :roles => :app do
  requires :webserver               # Apache or Nginx
  requires :appserver               # Passenger
  requires :ruby         # Ruby Enterprise edition
  requires :ruby_gems
  requires :database                # MySQL or Postgres, also installs rubygems for each
  requires :scm                     # Git

  requires :enroll
end

deployment do
  delivery :capistrano do
    begin
      recipes 'Capfile'
    rescue LoadError
      recipes 'deploy'
    end
  end
 
  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end
end

begin
  gem 'sprinkle', ">= 0.2.3" 
rescue Gem::LoadError
  puts "sprinkle 0.2.3 required.\n Run: `sudo gem install sprinkle`"
  exit
end