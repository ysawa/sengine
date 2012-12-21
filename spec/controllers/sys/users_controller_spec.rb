require 'spec_helper'

describe Sys::UsersController do

  before :each do
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

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', { id: @user.id }
        response.should be_success
      end
    end

    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit', { id: @user.id }
        response.should be_success
      end
    end
  end
end
