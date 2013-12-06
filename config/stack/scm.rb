package :git, :provides => :scm do
  apt 'git'
  
  verify do
    has_file '/usr/bin/git'
  end
end

package :git_dependencies do
  description 'Git Build Dependencies'
  apt 'git-core', :dependencies_only => true
end
