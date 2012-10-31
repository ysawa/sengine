# -*- coding: utf-8 -*-

class OfficialBot < Bot
  @queue = :bot_serve

  def work?
    Shogiengine.system.resque_work?
  end
end
