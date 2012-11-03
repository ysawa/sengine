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

  describe '.generate_both_kikis' do
    before :each do
      @game.create_first_board
      @game.sente_user = bot
      @game.gote_user = @game.author = @user
      @game.save
    end
    it 'successfully generates sente and gote kikis' do
      bot.game = @game
      kikis = bot.generate_kikis(@game.boards.last)
      kikis.should be_a Array
      sente_kikis = kikis.first
      sente_kikis.should be_a Kiki
      sente_kikis.get_move_kikis(16).should == [1] # FU
      sente_kikis.get_jump_kikis(16).should == [] # NONE
      sente_kikis.get_jump_kikis(17).should == [1] # KY
      sente_kikis.get_jump_kikis(18).should == [1, 10] # KY, HI
      gote_kikis = kikis.last
      gote_kikis.should be_a Kiki
      gote_kikis.get_move_kikis(14).should == [-1] # FU
      gote_kikis.get_jump_kikis(14).should == [] # NONE
      gote_kikis.get_jump_kikis(13).should == [-1, 9] # KY, KA
      gote_kikis.get_jump_kikis(12).should == [-1] # KY
      gote_kikis.get_jump_kikis(11).should == [11] # KA
    end
  end

  describe '.generate_valid_candidates' do
    before :each do
      @game.create_first_board
      @game.sente_user = bot
      @game.gote_user = @game.author = @user
      @game.save
    end
    it 'successfully generates candidates of movements' do
      bot.game = @game
      candidates = bot.generate_valid_candidates(true, @game.boards.last)
      candidates.should be_a Array
    end

    it 'successfully generates candidates of movements with putting movements' do
      bot.game = @game
      last_board = @game.boards.last
      last_board.p_97 = 0
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
    it 'successfully creates new movement' do
      @game.sente_user = bot
      @game.gote_user = @game.author = @user
      @game.save
      @game.number.should == 0
      bot.process_next_movement(@game)
      @game.number.should == 1
    end
  end
end
