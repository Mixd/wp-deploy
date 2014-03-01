# config valid only for Capistrano 3.1
lock '3.1.0'

############################################
# Setup Git
############################################

set :application, "wp-deploy"
set :repository, "git@github.com:Mixd/wp-deploy.git"
set :scm, :git
set :deploy_via, :remote_cache
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitmodules", "capfile", "config/"]

############################################
# Setup Server
############################################

set :use_sudo, false
set :ssh_options, {
  forward_agent: true
}

############################################
# Default tasks
############################################

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
