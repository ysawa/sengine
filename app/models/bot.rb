# -*- coding: utf-8 -*-

class Bot < User
  class InvalidConditions < StandardError; end
  @queue = :bot_serve

  def async_process_next_movement(game)
    game = find_game(game)
    Resque.enqueue(Bot, id, :process_next_movement, game.id)
  end

  def bot?
    true
  end

  def process_next_movement(game)
    game = find_game(game)
    false
  end

  def work?
    false
  end

protected

  def find_game(game)
    case game
    when Game
      game
    else
      Game.find(game)
    end
  end
end
