package :build_essential do
  description 'Build tools'
  apt 'build-essential libcurl4-openssl-dev' do
    pre :install, 'apt-get update'
  end
end
