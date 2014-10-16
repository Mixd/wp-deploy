namespace :uploads do

  desc "Push any changed or new files from local to remote"
  task :push do
    run_locally do
        roles(:all).each do |role|
                execute :rsync, "-avzO content/uploads/ #{role.user}@#{role.hostname}:#{shared_path}/content/uploads"
          end
      end
  end

  desc "Pull any changed or new files from remote to local"
  task :pull do
    run_locally do
        roles(:all).each do |role|
                execute :rsync, "-avzO #{role.user}@#{role.hostname}:#{shared_path}/content/uploads/ content/uploads"
          end
      end
  end

end