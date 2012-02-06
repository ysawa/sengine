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
end
