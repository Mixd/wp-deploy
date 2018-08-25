namespace :wp do

  ##############################################################################
  ## Set the necessary file permissions
  ##############################################################################

  desc 'Set the necessary file permissions'
  task :set_permissions do
    on roles(:app) do
      # Get the server web user
      web_user = fetch(:web_user)
      
      execute :chmod, "664 #{shared_path}/.htaccess"
      execute :chmod, "-R 775 #{shared_path}/content/uploads"
      execute :chown, ":#{web_user} #{shared_path}/content/uploads"
    end
  end

  namespace :setup do

    ############################################################################
    ## Generate template files
    ############################################################################

    desc 'Generate template files'
    task :generate_remote_files do
      on roles(:web) do
        # Get details for WordPress config file
        secret_keys = capture('curl -s -k https://api.wordpress.org/secret-key/1.1/salt')
        wp_siteurl = fetch(:stage_url)
        database = YAML.load_file('config/database.yml')[fetch(:stage).to_s]

        # Create template file paths based on the environment
        wpconfigFilePath = "config/templates/#{fetch(:stage)}/wp-config.php.erb"
        htaccessFilePath = "config/templates/#{fetch(:stage)}/.htaccess.erb"
        robotsFilePath = "config/templates/#{fetch(:stage)}/robots.txt.erb"

        # Create config file in remote environment
        db_config = ERB.new(File.read(wpconfigFilePath)).result(binding)
        io = StringIO.new(db_config)
        upload! io, File.join(shared_path, 'wp-config.php')

        # Create .htaccess in remote environment
        accessfile = ERB.new(File.read(htaccessFilePath)).result(binding)
        io = StringIO.new(accessfile)
        upload! io, File.join(shared_path, '.htaccess')

        # Create robots.txt in remote environment
        robotsfile = ERB.new(File.read(robotsFilePath)).result(binding)
        io = StringIO.new(robotsfile)
        upload! io, File.join(shared_path, 'robots.txt')
      end
      # Set some permissions
      invoke 'wp:set_permissions'
    end


    ############################################################################
    ## Setup WordPress on the remote environment
    ############################################################################

    desc 'Setup WordPress on the remote environment'
    task :remote do
      invoke 'db:confirm'
      invoke 'deploy'
      invoke 'wp:setup:generate_remote_files'
      on roles(:web) do
        within release_path do
          if !fetch(:setup_all)
            # Generate a random password
            o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
            password = (0...18).map { o[rand(o.length)] }.join
          else
            password = fetch(:wp_pass)
          end

          # Get WP details from config in /config
          wp_siteurl = fetch(:stage_url)
          title = fetch(:wp_sitename)
          email = fetch(:wp_email)
          user = fetch(:wp_user)

          # Install WordPress
          execute :wp, "core install --url='#{wp_siteurl}' --title='#{title}' --admin_user='#{user}' --admin_password='#{password}' --admin_email='#{email}'"

          unless fetch(:setup_all)
            puts <<-MSG
            \e[32m
            =========================================================================
              WordPress has successfully been installed. Here are your login details:

              Username:       #{user}
              Password:       #{password}
              Email address:  #{email}
              Log in at:      #{wp_siteurl}/wordpress/wp-admin
            =========================================================================
            \e[0m
            MSG
          end
        end
      end
    end


    ############################################################################
    ## Setup WordPress on the local environment
    ############################################################################

    desc 'Setup WordPress on the local environment'
    task :local do
      run_locally do
        if !fetch(:setup_all)
          # Generate a random password
          o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
          password = (0...18).map { o[rand(o.length)] }.join
        else
          password = fetch(:wp_pass)
        end

        # Get WP details from config in /config
        title = fetch(:wp_sitename)
        email = fetch(:wp_email)
        user = fetch(:wp_user)
        wp_siteurl = fetch(:wp_localurl)

        # Create wp-config.php
        database = YAML.load_file('config/database.yml')['local']
        secret_keys = capture('curl -s -k https://api.wordpress.org/secret-key/1.1/salt')
        db_config = ERB.new(File.read('config/templates/local/wp-config.php.erb')).result(binding)
        File.open('wp-config.php', 'w') { |f| f.write(db_config) }

        # Create .htaccess in local environment
        accessfile = ERB.new(File.read('config/templates/local/.htaccess.erb')).result(binding)
        File.open('.htaccess', 'w') { |f| f.write(accessfile) }

        # Create robots.txt in local environment
        robotsfile = ERB.new(File.read('config/templates/local/robots.txt.erb')).result(binding)
        File.open('robots.txt', 'w') { |f| f.write(robotsfile) }

        # Install WordPress
        execute :wp, "core install --url='#{wp_siteurl}' --title='#{title}' --admin_user='#{user}' --admin_password='#{password}' --admin_email='#{email}'"

        puts <<-MSG
        \e[32m
        =========================================================================
          WordPress has successfully been installed. Here are your login details:

          Username:       #{user}
          Password:       #{password}
          Email address:  #{email}
        =========================================================================
        \e[0m
        MSG
      end
    end


    ############################################################################
    ## Setup WordPress on both the local and remote environments
    ############################################################################

    desc 'Setup WordPress on both the local and remote environments'
    task :both do
      set :setup_all, true

      # Generate a random password
      o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      password = (0...18).map { o[rand(o.length)] }.join
      set :wp_pass, password

      # Setup remote and local envs
      invoke 'wp:setup:remote'
      invoke 'wp:setup:local'
    end
  end

  namespace :core do

    ############################################################################
    ## Update WordPress submodule to latest version
    ############################################################################

    desc 'Update WordPress submodule to latest version'
    task :update do
      system('
      cd wordpress
      git fetch --tags
      latestTag=$(git tag -l --sort -version:refname | head -n 1)
      git checkout $latestTag
      ')
      invoke 'cache:repo:purge'
      puts 'WordPress submodule is now at the latest version. You should now commit your changes.'
    end
  end
end
