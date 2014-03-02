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
# Setup project
############################################

set :application, "wp-deploy"
set :git_strategy, SubmoduleStrategy
set :repo_url, "git@github.com:Mixd/wp-deploy.git"
set :scm, :git

############################################
# Linked files and directories (symlinks)
############################################

# set :linked_files, %w{wp-config.php .htaccess}
set :linked_dirs, %w{content/uploads}