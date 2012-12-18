require 'spec_helper'

describe ProfileController do

  before :each do
    @opponent = Fabricate(:user, name: 'opponent')
  end

  context 'if NOT signed in' do
    describe "GET 'show'" do
      it "returns http redirect to new user session" do
        get 'show', id: @opponent.id.to_s
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  context 'if signed in' do

    before :each do
      user_sign_in
      @opponent = Fabricate(:user, name: 'opponent')
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', id: @opponent.id.to_s
        response.should be_success
        assigns[:user].should == @opponent
      end
    end
  end
end
