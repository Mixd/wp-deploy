# config valid only for Capistrano 3.1
lock '3.1.0'

############################################
# WordPress
############################################

set :wp_user, "support@mixd.co.uk" # The admin username
set :wp_email, "support@mixd.co.uk" # The admin email address
set :wp_sitename, "WP Deploy" # The site title

############################################
# Setup Capistrano
############################################

#set :log_level, :info
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

set :linked_files, %w{wp-config.php}
set :linked_dirs, %w{content/uploads}

namespace :deploy do	

  desc "create WordPress files for symlinking"
  task :create_wp_files do
    on roles(:app) do
      execute :touch, "#{shared_path}/wp-config.php"
    end
  end
  
  after 'check:make_linked_dirs', :create_wp_files

end