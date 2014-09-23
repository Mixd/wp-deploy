############################################
# Setup Server
############################################

set :stage, :production
set :stage_url, "http://www.example.com"
server "XXX.XXX.XX.XXX", user: "SSHUSER", roles: %w{web app db}
set :deploy_to, "/deploy/to/path"

############################################
# Setup Git
############################################

set :branch, "master"

############################################
# Extra Settings
############################################

#specify extra ssh options:

#set :ssh_options, {
#    auth_methods: %w(password),
#    password: 'password',
#    user: 'username',
#}

#specify a specific temp dir if user is jailed to home
#set :tmp_dir, "/path/to/custom/tmp"
