namespace :uploads do

  ##############################################################################
  ## Push any changed or new uploads from local to remote
  ##############################################################################

  desc 'Push any changed or new uploads from local to remote'
  task :push do
    run_locally do
      roles(:all).each do |role|
        execute :rsync, '-avzO' + (role.port ? " -e 'ssh -p #{role.port}'" : '') + " content/uploads/ #{role.user}@#{role.hostname}:#{shared_path}/content/uploads"
      end
    end
  end


  ##############################################################################
  ## Pull any changed or new uploads from remote to local
  ##############################################################################

  desc 'Pull any changed or new uploads from remote to local'
  task :pull do
    run_locally do
      roles(:all).each do |role|
        execute :rsync, '-avzO' + (role.port ? " -e 'ssh -p #{role.port}'" : '') + " #{role.user}@#{role.hostname}:#{shared_path}/content/uploads/ content/uploads"
      end
    end
  end

end
