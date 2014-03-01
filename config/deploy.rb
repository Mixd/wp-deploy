# config valid only for Capistrano 3.1
lock '3.1.0'

############################################
# Setup Capistrano
############################################

set :log_level, :info
set :use_sudo, false

set :ssh_options, {
  forward_agent: true
}

############################################
# Setup Git
############################################
set :git_strategy, SubmoduleStrategy
set :application, "wp-deploy"
set :repo_url, "git@github.com:Mixd/wp-deploy.git"
set :scm, :git