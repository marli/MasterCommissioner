set :application, "MasterCommissioner"
set :user, "marlibau"
set :branch, "master"
set :repository,  "git@github.com:marli/MasterCommissioner.git"
set :domain, 'marlibau@marlibaumann.com'
set :location, "marlibaumann.com"
set :deploy_to, "/home/marlibau/rails/#{application}"
set :deploy_via, :remote_cache
set :scm_command, "~/git/bin/git"
set :local_scm_command, "/usr/bin/git"
set :use_sudo, false
set :spinner, "false"
set :runner, user

set :scm, :git

role :app, location
role :web, location
role :db,  location, :primary => true
