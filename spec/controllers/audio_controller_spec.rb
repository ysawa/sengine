require 'spec_helper'

describe AudioController do

  describe "GET 'encode'" do
    before :each do
      get 'encode', filename: 'put', format: 'mp3'
    end

    it "returns http success" do
      response.should be_success
    end

    it "render text of encoded Data URI Scheme" do
      response.body.should match /^data:audio\/mp3/
    end
  end
end
