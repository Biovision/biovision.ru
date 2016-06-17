require 'pathname'

environment 'production'

app_root = File.realpath("#{File.dirname(Pathname.new(__FILE__))}/../")
logs_dir = "#{app_root}/log"
tmp_dir  = "#{app_root}/tmp"
pids_dir = "#{tmp_dir}/pids"

pidfile "#{pids_dir}/puma.pid"
state_path "#{tmp_dir}/puma.state"

bind "unix://#{tmp_dir}/puma.sock"

stdout_redirect "#{logs_dir}/stdout.log", "#{logs_dir}/stderr.log", true
