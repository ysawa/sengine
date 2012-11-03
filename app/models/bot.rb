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

  def give_up!(game)
    game = find_game(game)
    game.give_up!(self)
    game.apply_score_changes!
    game.create_facebook_won_feed
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
