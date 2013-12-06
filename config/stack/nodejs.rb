package :nodejs do
  description 'Node.js'
  version '0.10.22'
  source "http://nodejs.org/dist/v#{version}/node-v#{version}.tar.gz"
  requires :build_essential

   verify do
    has_executable "/usr/local/bin/node"
  end
end