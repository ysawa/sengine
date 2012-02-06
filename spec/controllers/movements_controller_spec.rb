require 'spec_helper'

describe MovementsController do

  before :each do
    user_sign_in
    @sente_user = @user
    @gote_user = Fabricate(:user)
    @game = Game.new(sente_user: @sente_user, gote_user: @gote_user)
    @game.save
    @game.boards << Board.hirate
    @game.save
  end

  def valid_attributes
    {
      game_id: @game.id.to_s,
      movement: {
        role: "fu",
        from_point: ["7", "3"],
        to_point: ["7", "4"],
        move: "true",
        put: "false",
        reverse: "false",
        sente: "true"
      }
    }
  end

  describe "GET 'create'" do
    it "returns http success" do
      post 'create', valid_attributes
      response.should redirect_to(game_url(@game))
    end
  end
end
