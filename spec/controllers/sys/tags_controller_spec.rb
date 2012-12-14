# -*- coding: utf-8 -*-

require 'spec_helper'

describe Sys::TagsController do

  before :each do
    @tag = Fabricate(:tag)
  end

  context 'without signing in as an admin'do
    describe "GET 'index'" do
      it "returns http redirect" do
        get 'index'
        response.should be_redirect
      end
    end
  end

  context 'with signing in as an admin'do
    before :each do
      @user = Fabricate(:user, admin: true)
      user_sign_in(@user)
    end

    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit', id: @tag.to_param
        response.should be_success
      end

      it 'finds corresponded tag' do
        get 'edit', id: @tag.to_param
        assigns[:tag].should == @tag
      end
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end

      it 'finds paged tags' do
        get 'index'
        assigns[:tags].should be_a Mongoid::Criteria
        assigns[:tags].to_a.should == [@tag]
      end
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', id: @tag.to_param
        response.should be_success
      end

      it 'finds corresponded tag' do
        get 'edit', id: @tag.to_param
        assigns[:tag].should == @tag
      end
    end
  end
end
