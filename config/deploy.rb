$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.3-p125@demo'
require "bundler/capistrano"
set :application, "demo-app"
set :repository, "git@gitorious.atomicobject.com:english/vagrant-rails.git" 

set :scm, :git

# We'll define these in environments below
role :web
role :app
role :db

namespace :environment do
  task :production do
    server "www.example.com", :app, :web, :db
    set :deploy_to, "/home/user/sites/demo-app"
    set :deploy_via, :remote_cache
  end
  task :vagrant do
    server "33.33.33.10", :app, :web, :db
    set :user, 'vagrant'
    ssh_options[:keys] = `vagrant ssh-config | grep IdentityFile`.split.last
    ssh_options[:forward_agent] = true
    set :use_sudo, false
    set :deploy_to, "/home/vagrant/sites/demo-app"
    set :deploy_via, :remote_cache
  end
end
