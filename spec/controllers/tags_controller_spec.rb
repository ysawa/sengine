# -*- coding: utf-8 -*-

require 'spec_helper'

describe TagsController do

  before :each do
    @tag = Fabricate(:tag)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', { id: @tag.to_param }
      response.should be_success
    end
  end
end
