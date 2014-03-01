############################################
# Setup Server
############################################

set :user, "SSHUSER"
set :host, "XXX.XXX.X.X"
server "#{host}", :app
set :deploy_to, "/var/www/EXAMPLE.COM/httpdocs"

############################################
# Setup Git
############################################

set :branch, "master"