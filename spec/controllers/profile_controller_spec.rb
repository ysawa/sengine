require 'spec_helper'

describe ProfileController do

  context 'if NOT signed in' do
    describe "GET 'show'" do
      it "returns http redirect" do
        get 'show'
        response.should be_redirect
      end
    end
  end

  context 'if signed in' do

    before :each do
      user_sign_in
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should be_success
      end
    end
  end
end
