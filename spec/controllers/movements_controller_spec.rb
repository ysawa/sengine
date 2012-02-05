require 'spec_helper'

describe MovementsController do

  before :each do
    user_sign_in
    @sente_user = @user
    @gote_user = Fabricate(:user)
    @game = Game.new(sente_user: @sente_user, gote_user: @gote_user)
    @game.boards << Board.hirate
    @game.save
  end

  describe "GET 'create'" do
    it "returns http success" do
      post 'create', { game_id: @game.id.to_s }
      response.should redirect_to(game_url(@game))
    end
  end
end
