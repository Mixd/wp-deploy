############################################
# Setup Server
############################################

set :stage, :production

server "mixd-server-master-002.mixd.co.uk", user: "mixdsftpuser", roles: %w{web app db}
set :deploy_to, "/var/www/aaronthomas.co.uk/httpdocs/cap"

############################################
# Setup Git
############################################

set :branch, "master"