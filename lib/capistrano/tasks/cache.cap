namespace :cache do

	namespace :repo do
		desc "Remove the cached repo from the server"
		task :purge do
			on roles(:web) do
				repopath = fetch(:deploy_to)
				execute :rm, "-rf #{repopath}/repo";
				puts "Cached repo folder removed from server."
			end

		end
	end

end