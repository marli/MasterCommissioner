set :application, "MasterCommissioner"
set :user, "marlibau"
set :branch, "master"
set :repository,  "git@github.com:marli/MasterCommissioner.git"
set :domain, 'marlibau@marlibaumann.com'
set :location, "marlibaumann.com"
set :deploy_to, "/home/marlibau/rails/#{application}"
set :deploy_via, :remote_cache

set :scm, :git

role :app, location
role :web, location
role :db,  location, :primary => true
