package :redis do
  description 'Redis Database'
  apt 'redis-server'
  verify do
    has_executable '/usr/bin/redis-server'
    has_file '/usr/bin/redis-server'
  end

  requires :build_essential
end