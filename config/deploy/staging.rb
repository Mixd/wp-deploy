############################################
# Setup Server
############################################
role :web, %w{mixdsftpuser@mixd-server-master-002.mixd.co.uk}
set :deploy_to, "/var/www/aaronthomas.co.uk/httpdocs/cap"

############################################
# Setup Git
############################################

set :branch, "master"