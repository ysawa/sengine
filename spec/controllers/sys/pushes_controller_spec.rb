require 'spec_helper'

describe Sys::PushesController do

  before :each do
    @push = Fabricate(:push)
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', { id: @push.to_param }
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
      get 'show', { id: @push.to_param }
      response.should be_success
    end
  end
end
