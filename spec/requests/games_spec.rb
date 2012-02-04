require 'spec_helper'

describe "Games" do
  describe "GET /games" do
    it "works! (now write some real specs)" do
      get games_path
      response.status.should be(200)
    end
  end
end
