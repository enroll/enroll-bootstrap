package :ruby_gems do
  gem :bundler
end

package :ruby do
  description 'Ruby'
  version '2.0.0'
  source "http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p353.tar.gz"
  requires :ruby_dependencies

   verify do
    has_executable "/usr/local/bin/ruby"
  end
end

package :ruby_dependencies do
  apt %w(zlib1g-dev libreadline-dev libssl-dev)
  requires :build_essential
end