require "bundler/capistrano"
set :application, "demo-app"
set :repository, "http://github.com/gazoombo/demo-app.git" 

set :scm, :git
role :web
role :app
role :db

task :production do
  server "www.example.com", :app, :web, :db
  set :deploy_to, "/home/user/sites/demo-app"
  set :deploy_via, :remote_cache
end

task :vagrant do
  server "33.33.33.10", :app, :web, :db
  set :user, 'vagrant'
  ssh_options[:keys] = `vagrant ssh-config | grep IdentityFile`.split.last
  set :deploy_to, "/home/vagrant/sites/demo-app"
  set :deploy_via, :remote_cache
end
