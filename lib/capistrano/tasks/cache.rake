namespace :cache do
  namespace :repo do

    ############################################################################
    ## Remove the cached repo folder from the server
    ############################################################################
    desc 'Remove the cached repo folder from the server'
    task :purge do
      on roles(:web) do

        # Get the path to the project
        repopath = fetch(:deploy_to)

        # Delete the repo cache folder
        execute :rm, "-rf #{repopath}/repo"

        # Display message to CLI
        puts 'Cached repo folder removed from server.'
      end
    end

  end
end
