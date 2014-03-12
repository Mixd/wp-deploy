# config valid only for Capistrano 3.1
lock '3.1.0'

############################################
# Setup WordPress
############################################

set :wp_user, "support@mixd.co.uk" # The admin username
set :wp_email, "support@mixd.co.uk" # The admin email address
set :wp_sitename, "WP Deploy" # The site title
set :wp_localurl, "http://wpdeploy" # Your local environment URL

############################################
# Setup project
############################################

set :application, "wp-deploy"
set :repo_url, "git@github.com:Mixd/wp-deploy.git"
set :scm, :git

set :git_strategy, SubmoduleStrategy

############################################
# Setup Capistrano
############################################

#set :log_level, :info
set :use_sudo, false

set :ssh_options, {
  forward_agent: true
}

############################################
# Linked files and directories (symlinks)
############################################

set :linked_files, %w{wp-config.php .htaccess}
set :linked_dirs, %w{content/uploads}

namespace :deploy do	

  desc "create WordPress files for symlinking"
  task :create_wp_files do
    on roles(:app) do
      execute :touch, "#{shared_path}/wp-config.php"
      execute :touch, "#{shared_path}/.htaccess"
    end
  end
  
  after 'check:make_linked_dirs', :create_wp_files

  desc "Creates robots.txt for non-production envs"
  task :create_robots do
  	on roles(:app) do
  		if fetch(:stage) != :production then

		    io = StringIO.new('User-agent: *
Disallow: /')
		    upload! io, File.join(release_path, "robots.txt")
      end
  	end
  end

  after :finished, :create_robots

end

namespace :git do
  
  desc "Reinitialise repo and fetch submodules"
  task :prepare do
    system('
      rm -rf .git
      git init
      rm -rf wordpress
      git submodule add git@github.com:WordPress/WordPress.git wordpress
      git remote rm origin
      git add -A
      git commit -m "Inital commit"
    ')

  end

end