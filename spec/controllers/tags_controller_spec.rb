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

    it "finds paged tags" do
      get 'index'
      assigns[:tags].should be_a Mongoid::Criteria
      assigns[:tags].to_a.should == [@tag]
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', { id: @tag.to_param }
      response.should be_success
    end

    it "finds tag with same code" do
      get 'show', { id: @tag.to_param }
      assigns[:tag].should == @tag
    end
  end

  describe "GET 'search'" do
    it "returns http success" do
      get 'search', q: 'tag'
      response.should be_success
    end

    it "finds paged tags" do
      get 'search', q: 'tag'
      assigns[:tags].should be_a Mongoid::Criteria
      assigns[:tags].to_a.should == [@tag]
    end
  end
end
