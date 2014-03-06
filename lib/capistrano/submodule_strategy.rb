module SubmoduleStrategy
  # do all the things a normal capistrano git session would do
  include Capistrano::Git::DefaultStrategy
  
  # check for a .git directory
  def test
    test! " [ -d #{repo_path}/.git ] "
  end
 
  # same as in Capistrano::Git::DefaultStrategy
  def check
    test! :git, :'ls-remote', repo_url
  end
 
  def clone
    git :clone, '-b', fetch(:branch), '--recursive', repo_url, repo_path
  end
 
  # same as in Capistrano::Git::DefaultStrategy
  def update
    git :remote, :update
  end
 
  # put the working tree in a release-branch,
  # make sure the submodules are up-to-date
  # and copy everything to the release path
  def release
    release_branch = fetch(:release_branch, File.basename(release_path))
    git :checkout, '-B', release_branch, 
      fetch(:remote_branch, "origin/#{fetch(:branch)}")
    git :submodule, :update, '--init'
    context.execute "rsync -ar --filter=':- .wpignore' --exclude=.git\* #{repo_path}/ #{release_path}"
  end
end