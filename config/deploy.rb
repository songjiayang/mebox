# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "mebox"
set :repo_url, "git@git.coding.net:songjiayang/mebox.git"

set :user, :deploy
set :use_sudo, false
set :git_enable_submodules, true

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :ssh_options, {
  forward_agent: true,
  port: 22,
  keys: [File.join(ENV["HOME"], ".ssh", "id_rsa")]
}

set :keep_releases, 5
