require 'spec_helper'

describe Sys::FeedbacksController do
  before :each do
    @feedback = Fabricate(:feedback)
    @user = Fabricate(:user, admin: true)
    user_sign_in(@user)
  end


  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
