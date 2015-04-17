namespace :db do

	desc "Creates a sensible backup name for SQL files"
  task :backup_name do
  	on roles(:web) do

	    now = Time.now
	    execute :mkdir, "-p #{shared_path}/db_backups"
	    backup_time = [now.year,now.month,now.day,now.hour,now.min,now.sec].join()
	    set :backup_filename, backup_time
	    set :backup_file, "#{shared_path}/db_backups/#{backup_time}.sql"

	  end
  end

  desc "Confirms the database action before proceeeding"
  task :confirm do
    on roles(:web) do

      database = YAML::load_file('config/database.yml')[fetch(:stage).to_s]

      set :confirmed, proc {
        puts <<-WARN
  \033[31m
  ========================================================================

    WARNING: You're about to overwrite the database!
    To continue, please enter the name of the database for this site.

    Datebase name:\033[0m \033[1m \033[34m #{database['database']} \033[0m \033[22m \033[31m

  ========================================================================
  \033[0m
        WARN
        ask :answer, database['database']
        if fetch(:answer) == database['database'] then
          true
        else
          loopCount = 1
          loop do
            loopCount = loopCount + 1
            puts "\033[31mYou typed the database name incorrectly. Please enter \033[0m\033[1m\033[34m#{database['database']}\033[0m\033[22m\033[0m\033[0m"
            ask :answer, database['database']
            break if loopCount == 3
            break if fetch(:answer) == database['database']
          end
        end

        if fetch(:answer) == database['database'] then
          true
        end
      }.call

      unless fetch(:confirmed)
        puts <<-WARN
  \033[31m
  ========================================================================
    Sorry, you have entered the database name incorrectly too many times
  ========================================================================
  \033[0m
        WARN
        exit
      end

    end
  end

  desc "Takes a database dump from remote server"
  task :backup do
	 invoke 'db:backup_name'
	  on roles(:db) do

	  	within release_path do
		     execute :wp, "db export #{fetch(:backup_file)} --add-drop-table"
		  end

		 system('mkdir -p db_backups')
		 download! "#{fetch(:backup_file)}", "db_backups/#{fetch(:backup_filename)}.sql"

		 within release_path do
		   execute :rm, "#{fetch(:backup_file)}"
		 end

	  end
	end

	desc "Imports the remote database into your local environment"
	task :pull do
		invoke 'db:backup'

		on roles(:db) do

			run_locally do
				execute :wp, "db import db_backups/#{fetch(:backup_filename)}.sql"
				execute :wp, "search-replace #{fetch(:stage_url)} #{fetch(:wp_localurl)}"
				execute :rm, "db_backups/#{fetch(:backup_filename)}.sql"

				if Dir['db_backups/*'].empty?
					execute :rmdir, "db_backups"
				end
			end

		end

	end

	desc "Imports the local database into your remote environment"
	task :push do

      invoke 'db:confirm'

		invoke 'db:backup_name'
		on roles(:db) do

			run_locally do
				execute :mkdir, "-p db_backups"
				execute :wp, "db export db_backups/#{fetch(:backup_filename)}.sql --add-drop-table"
			end

			upload! "db_backups/#{fetch(:backup_filename)}.sql", "#{fetch(:backup_file)}"

			within release_path do
				execute :wp, "db import #{fetch(:backup_file)}"
				execute :wp, "search-replace #{fetch(:wp_localurl)} #{fetch(:stage_url)}"
				execute :rm, "#{fetch(:backup_file)}"
			end

			run_locally do
				execute :rm, "db_backups/#{fetch(:backup_filename)}.sql"
				if Dir['db_backups/*'].empty?
					execute :rmdir, "db_backups"
				end
			end

		end
	end

end