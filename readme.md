wp-deploy
=========

A framework for deploying WordPress projects with Capistrano:

- Automates WordPress installations on any number of environments (including local)
- Automates database migrations between environments
- Removes all references to development URLs in production environments (and vice versa)
- Automatically sychronises your `uploads/` directories
- Helps keep deployment configs consistent across your team

Requirements
------------

For wp-deploy (or Capistrano in general) to work you need SSH access both between your local machine and your remote server, and between your local machine and your GitHub account.

Capistrano deploys your application into a symlinked `current/` directory on your server, so you'll need to set your document root to that folder.

Dependencies
---------------
Install Ruby dependencies using Bundler:

```
$ bundle install
```

wp-deploy also requires WP-CLI to be installed on all environments. See [the WP-CLI docs](http://wp-cli.org/#install) on how how to install it.

If you're using MAMP, you'll have issues when trying to run MySQL commands as the PHP version in MAMP is different to the one in your $PATH. You can fix this by adding the following two lines to your `.bash_profile` (or `.zshrc`):

```
export MAMP_PHP=/Applications/MAMP/bin/php/php5.4.4/bin
export PATH="$MAMP_PHP:$PATH"
```
Be sure you check the PHP version is correct and amend the path appropriately for your MAMP PHP version. see [this question on Stack Overflow](http://stackoverflow.com/questions/4145667/how-to-override-the-path-of-php-to-use-the-mamp-path/) for more info.

Configuration
---------------

First off, you need to set your global WP settings under the "WordPress" heading in `config/deploy.rb`:

```
set :wp_user, "aaronthomas" # The admin username
set :wp_email, "aaron@example.com" # The admin email address
set :wp_sitename, "WP Deploy" # The site title
set :wp_localurl, "http://localhost" # Your local environment URL
```

These are the settings used for your inital installation of WordPress. You also need to define your git repository in the same file:

```
set :application, "wp-deploy"
set :repo_url, "git@github.com:Mixd/wp-deploy.git"
```

wp-deploy starts you with 2 environments: staging and production. You need to set up your individual environment settings in `config/deploy/staging.rb` and `config/deploy/production.rb`:

```
set :stage_url, "http://www.example.com"
server "XXX.XXX.XX.XXX", user: "SSHUSER", roles: %w{web app db}
set :deploy_to, "/deploy/to/path"
```
This is where you define your SSH access to the remote server, and the full path which you plan to deploy to. the `stage_url` is used when generating your `wp-config.php` file during installation.

You also need to rename `database.example.yml` to `database.yml` and fill it with the database details for each environment, including your local one. This file should stay ignored in git.

Getting started
---------------

To set up WordPress on your remote server, run the following command:

```
$ bundle exec cap production wp:setup:remote
```
This will install WordPress using the details in your configuration files, and make your first deployment on your production server. wp-deploy will generate a random password and give it to you at the end of the task, so be sure to write it down and change it to something more momorable when you log in.

You can also automate the set-up of your local environment too, using `wp:setup:local`, or you can save time and set up both your remote and local environments with `wp:setup:both`.

To make future deployments, use:

```
$ bundle exec cap production deploy
```

You can define either `production` or `staging` in any command to deploy to different environments.

Usage
-----

### database migrations

### Syncing uploads

### Quick deployments
