$:<< File.join(File.dirname(__FILE__), 'stack')

['ENROLL_ENV', 'ENROLL_HOST'].each do |e|
  if !ENV[e] || ENV[e] == ''
    raise "Missing argument: #{e}"
  end
end

require 'essential'
require 'scm'
require 'ruby'
require 'nodejs'
require 'postgresql'
require 'enroll'
require 'apache'
require 'redis'

policy :stack, :roles => :app do
  requires :webserver               # Apache or Nginx
  requires :appserver               # Passenger
  requires :ruby
  requires :ruby_gems
  requires :nodejs
  requires :database                # MySQL or Postgres, also installs rubygems for each
  requires :scm                     # Git
  requires :redis

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