############################################
# Setup Server
############################################

set :stage, :staging
set :stage_url, "http://test.mixd.co.uk"
server "staging-server-master-001.mixd.co.uk", user: "mixdsftpuser", roles: %w{web app db}
set :deploy_to, "/var/www/vhosts/test.mixd.co.uk/httpdocs"

############################################
# Setup Git
############################################

set :branch, "master"