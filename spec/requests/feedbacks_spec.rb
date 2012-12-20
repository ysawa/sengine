require 'spec_helper'

describe "Feedbacks" do
  before :each do
    @current_user = Fabricate(:user)
  end

  describe "GET /feedbacks" do
    it "can be accessed" do
      user_sign_in_with_post(@current_user, 'PASSWORD')
      get feedbacks_path
      response.status.should be(200)
    end
  end
end
