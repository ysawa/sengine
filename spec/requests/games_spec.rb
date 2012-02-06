require 'spec_helper'

describe "Games" do

  describe "GET /games" do
    context 'if user signed in' do
      before :each do
        @current_user = Fabricate(:user)
        user_sign_in_with_post(@current_user, 'testtest')
      end

      it "works!" do
        get games_path
        response.status.should be(200)
      end
    end

    context 'if user NOT signed in' do
      it "doesn't work." do
        get games_path
        response.status.should be(302)
      end
    end
  end

  describe "GET /games/1" do
    context 'if user signed in' do
      before :each do
        @sente_user = Fabricate(:user)
        @gote_user = Fabricate(:user)
        @game = Game.new
        @game.boards << Board.hirate
        @game.sente_user = @sente_user
        @game.gote_user = @gote_user
      end

      it "works!" do
        user_sign_in_with_post(@sente_user, 'testtest')
        get game_path(@game)
        response.status.should be(200)
      end
    end

    context 'if user NOT signed in' do
      it "doesn't work." do
        get game_path(@game)
        response.status.should be(302)
      end
    end
  end
end
