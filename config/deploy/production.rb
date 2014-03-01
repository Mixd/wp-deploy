############################################
# Setup Server
############################################

set :stage, :production

server "XXX.XXX.XX.XXX", user: "SSHUSER", roles: %w{web app db}
set :deploy_to, "/deploy/to/path"

############################################
# Setup Git
############################################

set :branch, "master"