# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Includes YAML
require 'yaml'

# Include custom strategy for deploying git submodules
require 'capistrano/git'
require './lib/capistrano/submodule_strategy'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
