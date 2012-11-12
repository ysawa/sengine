# -*- coding: utf-8 -*-

require 'spec_helper'

describe MinnaBot do
  before :each do
    @user = Fabricate :user
    @game = Fabricate :game
  end

  let :bot do
    Fabricate(:minna_bot)
  end

  describe '.bot?' do
    it 'should be true' do
      bot.should be_true
    end
  end

  describe '.encode_board' do
    before :each do
      @game.create_first_board
      @board = @game.boards.last
    end
    it 'successfully creates a new board for SBot' do
      bot_board = bot.encode_board(@board)
      bot_board.number.should == @board.number
      bot_board.board[75].should == SBot::Piece::FU
      bot_board.board[95].should == SBot::Piece::OU
      bot_board.board[35].should == - SBot::Piece::FU
    end
  end

  describe '.encode_board' do
    before :each do
      @bot_move = SBot::Move.new(from_point: 75, to_point: 65, put: false, reverse: false)
    end
    it 'successfully creates a new board for SBot' do
      @movement = bot.decode_movement(@bot_move)
      @movement.reverse.should == @bot_move.reverse
      @movement.put.should == @bot_move.put
      @movement.from_point.should == Point.new(5, 7)
      @movement.to_point.should == Point.new(5, 6)
    end
  end

  describe '.process_next_movement' do
    before :each do
      @game.create_first_board
      @another_bot = MinnaBot.new
    end
    it 'successfully creates new movement' do
      @game.sente_user = bot
      @game.gote_user = @game.author = @user
      @game.save
      @game.number.should == 0
      bot.process_next_movement(@game)
      @game.number.should == 1
    end

    it 'successfully works as a player without errors' do
      @game.sente_user = bot
      @game.gote_user = @game.author = @another_bot
      @game.save
      3.times do
        bot.process_next_movement(@game)
        @another_bot.process_next_movement(@game)
      end
      @game.number.should == 6
    end
  end
end
