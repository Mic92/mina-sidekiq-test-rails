require 'mina'
require 'mina_sidekiq/tasks'
require 'mina/git'
require 'mina/bundler'
require 'mina/rvm'
require 'fileutils'

FileUtils.mkdir_p "#{Dir.pwd}/deploy"

set :domain, 'localhost'
set :deploy_to, "#{Dir.pwd}/deploy"
set :shared_paths, ['log', 'Gemfile', 'Gemfile.lock', 'sidekiq.yml']
set :keep_releases, 2

task :environment do
  invoke :'rvm:use[ruby-2.0.0]'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[mkdir -p "#{deploy_to}/shared/config"]
end

task :deploy => :environment do
  deploy do
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'sidekiq:start'

    # stop accepting new workers
    #invoke :'sidekiq:quiet'

    invoke :'sidekiq:stop'
  end
end
