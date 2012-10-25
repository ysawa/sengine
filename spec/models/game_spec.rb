# -*- coding: utf-8 -*-

require 'spec_helper'

describe Game do
  describe '.save' do
    let :game do
      Fabricate.build(:game)
    end
    it 'works!' do
      game.save.should be_true
    end
  end

  describe '.author' do
    before :each do
      @user = Fabricate(:user)
      @game = Fabricate(:game)
    end
    it 'works!' do
      @game.author = @user
      @game.save
      @game = Game.find(@game.id)
      @game.author.should == @user
    end
  end

  describe '.sente_user' do
    before :each do
      @user = Fabricate(:user)
      @game = Fabricate(:game)
    end
    it 'works!' do
      @game.sente_user = @user
      @game.save
      @game = Game.find(@game.id)
      @game.sente_user.should == @user
    end
  end

  describe '.gote_user' do
    before :each do
      @user = Fabricate(:user)
      @game = Fabricate(:game)
    end
    it 'works!' do
      @game.gote_user = @user
      @game.save
      @game = Game.find(@game.id)
      @game.gote_user.should == @user
    end
  end

  describe '.gote_user' do
    before :each do
      @sente_user = Fabricate(:user)
      @gote_user = Fabricate(:user)
      @game = Fabricate(:game)
    end
    it 'works!' do
      @game.sente_user = @sente_user
      @game.gote_user = @gote_user
      @game.save
      @game = Game.find(@game.id)
      @game.users.should == [@sente_user, @gote_user]
    end
  end

  describe '.make_board_from_movement' do
    before :each do
      @game = Fabricate(:game)
      @game.boards << Board.hirate
      @movement = Fabricate.build(:movement)
    end

    it 'works!' do
      @game.boards.count.should == 1
      @game.make_board_from_movement(@movement)
      @game.boards.count.should == 2
    end
  end

  describe '.handicap' do
    before :each do
      @sente_user = Fabricate(:user, name: 'sente')
      @gote_user = Fabricate(:user, name: 'gote')
      @game = Fabricate(:game, sente_user: @sente_user, gote_user: @gote_user)
    end

    it 'hirate is not a handicap' do
      @game.handicap = nil
      @game.handicapped?.should be_false
      @game.create_first_board
      board = @game.boards.first
      board.p_28.should == Piece::HI
      board.p_88.should == Piece::KA
      board.p_19.should == Piece::KY
      board.p_99.should == Piece::KY
      board.p_29.should == Piece::KE
      board.p_89.should == Piece::KE
      board.p_39.should == Piece::GI
      board.p_79.should == Piece::GI
      board.p_49.should == Piece::KI
      board.p_69.should == Piece::KI
    end

    it "hi is sente's handicap" do
      @game.handicap = 'hi'
      @game.handicapped?.should be_true
      @game.create_first_board
      board = @game.boards.first
      board.p_28.should == 0
      board.p_88.should == Piece::KA
      board.p_19.should == Piece::KY
      board.p_99.should == Piece::KY
      board.p_29.should == Piece::KE
      board.p_89.should == Piece::KE
      board.p_39.should == Piece::GI
      board.p_79.should == Piece::GI
      board.p_49.should == Piece::KI
      board.p_69.should == Piece::KI
    end

    it "four is sente's handicap" do
      @game.handicap = 'four'
      @game.handicapped?.should be_true
      @game.create_first_board
      board = @game.boards.first
      board.p_28.should == 0
      board.p_88.should == 0
      board.p_19.should == 0
      board.p_99.should == 0
      board.p_29.should == Piece::KE
      board.p_89.should == Piece::KE
      board.p_39.should == Piece::GI
      board.p_79.should == Piece::GI
      board.p_49.should == Piece::KI
      board.p_69.should == Piece::KI
    end

    it "six is sente's handicap" do
      @game.handicap = 'six'
      @game.handicapped?.should be_true
      @game.create_first_board
      board = @game.boards.first
      board.p_28.should == 0
      board.p_88.should == 0
      board.p_19.should == 0
      board.p_99.should == 0
      board.p_29.should == 0
      board.p_89.should == 0
      board.p_39.should == Piece::GI
      board.p_79.should == Piece::GI
      board.p_49.should == Piece::KI
      board.p_69.should == Piece::KI
    end

    it "eight is sente's handicap" do
      @game.handicap = 'eight'
      @game.handicapped?.should be_true
      @game.create_first_board
      board = @game.boards.first
      board.p_28.should == 0
      board.p_88.should == 0
      board.p_19.should == 0
      board.p_99.should == 0
      board.p_29.should == 0
      board.p_89.should == 0
      board.p_39.should == 0
      board.p_79.should == 0
      board.p_49.should == Piece::KI
      board.p_69.should == Piece::KI
    end

    it "ten is sente's handicap" do
      @game.handicap = 'ten'
      @game.handicapped?.should be_true
      @game.create_first_board
      board = @game.boards.first
      board.p_28.should == 0
      board.p_88.should == 0
      board.p_19.should == 0
      board.p_99.should == 0
      board.p_29.should == 0
      board.p_89.should == 0
      board.p_39.should == 0
      board.p_79.should == 0
      board.p_49.should == 0
      board.p_69.should == 0
    end
  end
end
