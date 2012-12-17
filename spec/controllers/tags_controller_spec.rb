# -*- coding: utf-8 -*-

require 'spec_helper'

describe TagsController do

  before :each do
    @tag = Fabricate(:tag)
  end

  context 'without signing in' do
    describe "GET 'index'" do
      it "returns http redirect" do
        get 'index'
        response.should be_redirect
      end
    end
  end

  context 'with signing in' do
    before :each do
      user_sign_in
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
end
