# -*- coding: utf-8 -*-

class Bot < User
  @queue = :bot_serve

  def bot?
    true
  end

  def find_next_movement(game)
  end

  def work?
    false
  end

  class << self
    def perform(bot_id, method_name, *arguments)
      bot = find(bot_id)
      bot.public_send(method_name, *arguments)
    end
  end
end
