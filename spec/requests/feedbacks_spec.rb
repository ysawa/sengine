require 'spec_helper'

describe "Feedbacks" do
  before :each do
    @current_user = Fabricate(:user)
  end

  describe "GET /feedbacks" do
    it "works! (now write some real specs)" do
      user_sign_in_with_post(@current_user, 'testtest')
      get feedbacks_path
      response.status.should be(200)
    end
  end
end
