package :build_essential do
  description 'Build tools'
  apt 'build-essential libcurl4-openssl-dev' do
    pre :install, 'apt-get update'
  end

  verify do
    has_executable "/usr/bin/gcc"
  end
end
