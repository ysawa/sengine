require 'spec_helper'

describe GamesController do

  def valid_attributes(attributes = {})
    {}.merge(attributes)
  end

  def valid_session
    {}
  end

  context 'if NOT signed in' do
    describe "GET index" do
      it "assigns all games as @games" do
        game = Game.create! valid_attributes
        get :index, {}
        response.should be_redirect
      end
    end
  end

  context 'if signed in' do

    before :each do
      user_sign_in
      @opponent = Fabricate(:user, name: 'opponent')
    end

    describe "GET index" do
      it "assigns all games as @games" do
        game = Game.create! valid_attributes
        get :index, {}
        assigns(:games).should eq([game])
      end
    end

    describe "GET playing" do
      it "assigns all games as @games" do
        game = Game.create! valid_attributes(sente_user: @user)
        get :playing, {}
        assigns(:games).to_a.should eq([game])
      end

      it "assigns all games as @games" do
        game = Game.create! valid_attributes({ playing: false, sente_user: @user })
        get :playing, {}
        assigns(:games).should eq([])
      end
    end

    describe "GET mine" do
      it "assigns all games as @games" do
        game = Game.create! valid_attributes
        get :mine, {}
        assigns(:games).should eq([])
      end

      it "assigns all games as @games" do
        game = Game.create! valid_attributes({ sente_user: @user })
        get :mine, {}
        assigns(:games).should eq([game])
      end
    end

    describe "GET show" do
      it "assigns the requested game as @game" do
        game = Game.create! valid_attributes
        board = Board.hirate
        game.boards << board
        get :show, { id: game.to_param }
        assigns(:game).should eq(game)
      end
    end

    describe "GET new" do
      it "assigns a new game as @game" do
        get :new, {}
        assigns(:game).should be_a_new(Game)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Game" do
          expect {
            post :create, { game: valid_attributes, game_opponent_id: @opponent.id.to_s }
          }.to change(Game, :count).by(1)
        end

        it "assigns a newly created game as @game" do
          post :create, { game: valid_attributes, game_opponent_id: @opponent.id.to_s }
          assigns(:game).should be_a(Game)
          assigns(:game).should be_persisted
        end

        it "redirects to the created game" do
          post :create, { game: valid_attributes, game_opponent_id: @opponent.id.to_s }
          response.should redirect_to(Game.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved game as @game" do
          # Trigger the behavior that occurs when invalid params are submitted
          Game.any_instance.stub(:save).and_return(false)
          post :create, { game: {} }
          assigns(:game).should be_a_new(Game)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Game.any_instance.stub(:save).and_return(false)
          post :create, { game: {} }
          response.should render_template("new")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested game" do
        game = Game.create! valid_attributes
        expect {
          delete :destroy, { id: game.to_param }
        }.to change(Game, :count).by(-1)
      end

      it "redirects to the games list" do
        pending 'test not correct'
        game = Game.create! valid_attributes
        delete :destroy, { id: game.to_param, format: 'html' }
        response.should redirect_to(games_path)
      end
    end
  end
end
