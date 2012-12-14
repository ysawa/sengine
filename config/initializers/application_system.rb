# -*- coding: utf-8 -*-

module Sengine
  class System
    def site
      @system[:site] || {}
    end

    def facebook
      @system[:facebook] || {}
    end

    def initialize
      system = YAML.load_file File.join(Rails.root, 'config', 'system.yml')
      @system = HashWithIndifferentAccess.new system
    end

    def resque_work?
      pid_file = File.join(Rails.root, 'tmp/pids/resque.pid')
      system("kill -0 `cat #{pid_file}`")
    end
  end

  def system
    @@system ||= System.new
  end
  module_function :system
end
