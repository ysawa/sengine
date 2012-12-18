require 'spec_helper'

describe Sys::GamesController do
  before :each do
    @game = Fabricate(:game)
    @user = Fabricate(:user, admin: true)
  end

  context 'without signing in as an admin'do
    describe "GET 'index'" do
      it "returns http redirect to new user session" do
        get 'index'
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  context 'with signing in as an admin'do

    before :each do
      user_sign_in(@user)
    end

    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit', id: @game.to_param
        response.should be_success
      end
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', id: @game.to_param
        response.should be_success
      end
    end
  end
end
