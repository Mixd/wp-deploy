# wp-deploy

A framework for deploying WordPress projects with Capistrano:

- Automates WordPress deployments via git/github on any number of environments
- Automates database migrations between environments
- Removes all references to development URLs in production environments (and vice versa)
- Sychronises your WordPress `uploads/` directories between environments
- Automatically prevents non-production environments from being crawled by search engines

Note that wp-deploy is pretty strict about how you work with WordPress and git, and it may be different to what you're used to. Be sure to read [Notes on WordPress development](https://github.com/Mixd/wp-deploy/wiki/Notes-on-WordPress-development) before starting.

## Requirements

For wp-deploy (or Capistrano in general) to work you need SSH access both between your local machine and your remote server, and between your local machine and your GitHub account.

Capistrano deploys your application into a symlinked `current/` directory on your server, so you'll need to set your document root to that folder.

- **Bundler**: As WP-Deploy comes with various different Ruby Dependencies, Bundler is used to make quick work of the installation process. Here's the [link](http://bundler.io/)
- **WP-CLI**: WP-Deploy also requires the automation of WordPress functions directly in the Command Line. As these functions are required on all environments (local, staging and production servers), we make use of the WordPress Command Line Interface. You can check out the [documentation](http://wp-cli.org/#install) on how to get this setup.s

### Keep in Mind
If you're using MAMP, you'll have issues when trying to run MySQL commands as the PHP version in MAMP is different to the one in your $PATH. You can fix this by adding the following two lines to your `.bash_profile` (or `.zshrc`):

```sh
export MAMP_PHP=/Applications/MAMP/bin/php/php5.4.4/bin
export PATH="$MAMP_PHP:$PATH"
```

Be sure you check the PHP version is correct and amend the path appropriately for your MAMP PHP version. see [this question on Stack Overflow](http://stackoverflow.com/questions/4145667/how-to-override-the-path-of-php-to-use-the-mamp-path/) for more info.

- - -

## Installation
Here's a step by step guide of getting **WP-Deploy** setup.

### Getting started

Firstly, you're going to need to clone the repository. There are a number of ways in which you can do this, however, seeing as this workflow requires the use of the Command Line, I'd recommend doing it in that.

```sh
cd my/desired/directory
git clone --recursive https://github.com/Mixd/wp-deploy.git new-project
```

That will clone the repository into a folder name of your choosing and it'll also download any submodules included within the repository. In this case, we have included WordPress.

Next, we need to reinialise it as its own repository rather than having it connected to the current origin. We've create a simple bash script that does most of the leg work for you, so once you've cloned the repo just run:

```sh
$ bash config/prepare.sh
```
Then all you need to do is add your own remote origin repository:

```sh
$ git remote add origin <repo_url>
```

And finally, install the Ruby dependencies for the framework via Bundler:

```sh
$ bundle install
```

You're now ready to set up your configuration files.

### Configuration

First off, you need to set your global WP settings under the "WordPress" heading in `config/deploy.rb`:

```ruby
set :wp_user, "aaronthomas" # The admin username
set :wp_email, "aaron@example.com" # The admin email address
set :wp_sitename, "WP Deploy" # The site title
set :wp_localurl, "http://localhost" # Your local environment URL
```

These are the settings used for your inital installation of WordPress. You also need to define your git repository in the same file:

```ruby
set :application, "wp-deploy"
set :repo_url, "git@github.com:Mixd/wp-deploy.git"
```

wp-deploy starts you with 2 environments: staging and production. You need to set up your individual environment settings in `config/deploy/staging.rb` and `config/deploy/production.rb`:

```ruby
set :stage_url, "http://www.example.com"
server "XXX.XXX.XX.XXX", user: "SSHUSER", roles: %w{web app db}
set :deploy_to, "/deploy/to/path"
set :branch, "master"
```
This is where you define your SSH access to the remote server, and the full path which you plan to deploy to. the `stage_url` is used when generating your `wp-config.php` file during installation.

`server` can be an IP address or domain; prefixing with `http://` is not needed either way. 

You also need to rename `database.example.yml` to `database.yml` and fill it with the database details for each environment, including your local one. This file should stay ignored in git.

#### .wpignore

By default, Capistrano deploys every file within in your repo, including config files, dotfiles, and various other stuff that's of no use on your remote environment. To get around this, wp-deploy uses a `.wpignore` file which lists all files and directories you don't want to be deployed, in a similar way to how `.gitginore` prevents files from being checked into your repo.

#### Slack Integration

wp-deploy makes use of [capistrano-slackify](https://github.com/onthebeach/capistrano-slackify) to trigger deployment notifactions to Slack. This is optional, but can be pretty handy if you're a Slack user. You just need to add your Slack incoming webhook token and subdomain in the `config/slack.rb` and you're good to go.


### Usage

#### Setting up environments

To set up WordPress on your remote production server, run the following command:

```sh
$ bundle exec cap production wp:setup:remote
```

This will install WordPress using the details in your configuration files, and make your first deployment on your production server. wp-deploy will generate a random password and give it to you at the end of the task, so be sure to write it down and change it to something more momorable when you log in.

You can also automate the set-up of your local environment too, using `wp:setup:local`, or you can save time and set up both your remote and local environments with `wp:setup:both`.

#### Deploying

To deploy your codebase to the remote server:

```sh
$ bundle exec cap production deploy
```

That will deploy everything in your repository and submodules, excluding any files and directories in your `.wpignore` file.

#### Database migrations

__WARNING__: Always use caution when migrating databases on live production environments – This cannot be undone and can cause some pretty serious issues if you're not fully aware of what you're doing.

Migrating databases will also automatically replace development URLs from production databases and vice versa.

To push your local database to the remote evironment:

```sh
$ bundle exec cap production db:push
```

To pull the remote database into your local evironment:

```sh
$ bundle exec cap production db:pull
```

To take a backup of the remote database (without importing to your local env.):

```sh
$ bundle exec cap production db:backup
```

That will save an `.sql` file into a local `db_backups/` directory within your project. All `.sql` files are – and should stay – git ignored.

#### Syncing uploads

You can pull and push the WordPress uploads directory in the same way as you can with a database. Pushing from local to an environment or Pulling from an environment to local:

```sh
$ bundle exec cap production uploads:pull
$ bundle exec cap production uploads:push
```

#### Updating WordPress core

To update the WordPress submodule to the latest version, run:

```sh
$ bundle exec cap production wp:core:update
```
