################################################################################
## Setup Environment
################################################################################

# The Git branch this environment should be attached to.
set :branch, 'master'

# The environment's name. To be used in commands and other references.
set :stage, :production

# The URL of the website in this environment.
set :stage_url, 'http://www.example.com'

# The environment's server credentials
server 'XXX.XXX.XX.XXX', user: 'SSHUSER', roles: %w(web app db)

# The deploy path to the website on this environment's server.
set :deploy_to, '/deploy/to/path'

# The web user on this environment's server.
set :web_user, 'www-data'
