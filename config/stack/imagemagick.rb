package :imagemagick do
  description 'imagemagick'
  
  apt 'imagemagick'
  
  verify do
    has_executable '/usr/bin/convert'
  end
end