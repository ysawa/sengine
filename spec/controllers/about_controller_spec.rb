require 'spec_helper'

describe AboutController do

  describe "GET 'game'" do
    it "returns http success" do
      get 'game'
      response.should be_success
    end
  end
end
