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

  describe '.generate_valid_candidates' do
    before :each do
      @game.create_first_board
      @game.sente_user = bot
      @game.gote_user = @game.author = @user
      @game.save
    end
    it 'successfully generate candidates of movements' do
      bot.game = @game
      candidates = bot.generate_valid_candidates(true, @game.boards.last)
      candidates.should be_a Array
    end

    it 'successfully generate candidates of movements with putting movements' do
      bot.game = @game
      last_board = @game.boards.last
      last_board.p_79 = 0
      sente_hand = last_board.sente_hand
      sente_hand['fu'] = 1
      last_board.sente_hand = sente_hand
      last_board.save
      candidates = bot.generate_valid_candidates(true, @game.boards.last)
      candidates.should be_a Array
      candidates.last.put.should be_true
    end
  end

  describe '.process_next_movement' do
    before :each do
      @game.create_first_board
    end
    it 'successfully create new movement' do
      @game.sente_user = bot
      @game.gote_user = @game.author = @user
      @game.save
      @game.number.should == 0
      bot.process_next_movement(@game)
      @game.number.should == 1
    end
  end
end
