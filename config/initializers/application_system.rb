# -*- coding: utf-8 -*-

module Shogiengine
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
  end

  def system
    @@system ||= System.new
  end
  module_function :system
end
