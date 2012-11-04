# -*- coding: utf-8 -*-

class MinnaBot < Bot
  @queue = :bot_serve

  attr_accessor :bot_sente
  attr_accessor :game
  attr_accessor :last_board

  def process_next_movement(game)
    @game = find_game(game)
    @bot_sente = @game.sente_user_id == id
    @last_board = @game.boards.last
    if @last_board.sente? == @bot_sente
      raise Bot::InvalidConditions.new 'turn is invalid'
    end
    estimator = ShogiBot::Estimator.new
    kikis = estimator.generate_kikis(@last_board)
    candidates = estimator.generate_valid_candidates(@bot_sente, @last_board, kikis)
    if candidates.size == 0
      give_up!(@game)
    else
      new_movement = candidates.sample
      @game.make_board_from_movement!(new_movement)
    end
  end

  def score
    5000
  end

  def work?
    true
  end
end
