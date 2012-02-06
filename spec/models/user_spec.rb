require 'spec_helper'

describe User do
  describe '.save' do
    let(:user) { User.new }

    context 'with invalid attributes' do
      it 'works!' do
        user.save.should be_false
      end
    end

    context 'with invalid attributes' do
      before :each do
        user.attributes = {
          email: 'test@leaping.jp',
          password: 'testtest',
          password_confirmation: 'testtest'
        }
      end

      it 'works!' do
        user.save.should be_true
      end
    end
  end

  describe '.sente_games' do
    before :each do
      @user = Fabricate(:user)
    end

    it 'works!' do
      game = Game.new
      @user.sente_games << game
      @user = User.find(@user.id)
      @user.sente_games.should == [game]
    end
  end

  describe '.gote_games' do
    before :each do
      @user = Fabricate(:user)
    end

    it 'works!' do
      game = Game.new
      @user.gote_games << game
      @user = User.find(@user.id)
      @user.gote_games.should == [game]
    end
  end
end
