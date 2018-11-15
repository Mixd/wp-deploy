################################################################################
## Setup project
################################################################################

# Lock the project to Capistrano 3.11.0
lock '3.11.0'

# The WordPress admin user
set :wp_user, 'yourname'

# The WordPress admin email address
set :wp_email, 'yourname@example.com'

# The WordPress 'Site Title' for the website
set :wp_sitename, 'WP Deploy'

# The local environment URL.
set :wp_localurl, 'http://wpdeploy.local'

# An identifying name for the application to be used by Capistrano
set :application, 'wp-deploy'
set :repo_url, 'git@github.com:Mixd/wp-deploy.git'


################################################################################
## Setup Capistrano
################################################################################

set :log_level, :debug
set :keep_releases, 2
set :use_sudo, false
set :ssh_options, forward_agent: true


################################################################################
## Linked files and directories (symlinks)
################################################################################

set :linked_files, %w(wp-config.php .htaccess robots.txt)
set :linked_dirs, %w(content/uploads)

namespace :deploy do
  desc 'create WordPress files for symlinking'
  task :create_wp_files do
    on roles(:app) do
      execute :touch, "#{shared_path}/wp-config.php"
      execute :touch, "#{shared_path}/.htaccess"
      execute :touch, "#{shared_path}/robots.txt"
    end
  end

  after 'check:make_linked_dirs', :create_wp_files
  after :finishing, 'deploy:cleanup'
end
