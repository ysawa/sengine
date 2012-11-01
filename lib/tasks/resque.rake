require 'resque/tasks'

task "resque:setup" => :environment do
  require 'resque'
  Resque.redis.namespace = "resque:Shogiengine"
end
