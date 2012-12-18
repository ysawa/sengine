# -*- coding: utf-8 -*-

require 'spec_helper'

describe Sys::TagsController do

  def valid_attributes(attributes = {})
    attrs = { code: 'tag_code', name: 'Tag Name', content: 'Tag Content' }
    attrs.merge(attributes)
  end

  before :each do
    @tag = Fabricate(:tag)
  end

  context 'without signing in as an admin'do
    describe "GET 'index'" do
      it "returns http redirect" do
        get 'index'
        response.should redirect_to(new_user_session_path)
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
        get 'show', id: @tag.to_param
        assigns[:tag].should == @tag
      end
    end

    describe "GET 'new'" do
      it "returns http success" do
        get 'new'
        response.should be_success
      end

      it 'build new tag' do
        get 'new'
        assigns[:tag].persisted?.should be_false
      end
    end

    describe "POST 'create'" do
      context 'with valid attributes' do
        it "returns http redirect" do
          post 'create', { 'tag' => valid_attributes }
          response.should be_redirect
        end

        it "creates new tag" do
          Tag.count.should == 1
          post 'create', { 'tag' => valid_attributes }
          Tag.count.should == 2
        end
      end

      context 'with invalid attributes' do
        it "renders edit" do
          post 'create', { 'tag' => valid_attributes(code: '') }
          response.should render_template(:edit)
        end
      end
    end

    describe "PUT 'update'" do
      context 'with valid attributes' do
        it "returns http redirect" do
          put 'update', { 'id' => @tag.to_param, 'tag' => valid_attributes }
          response.should be_redirect
        end
      end

      context 'with invalid attributes' do
        it "renders edit" do
          put 'update', { 'id' => @tag.to_param, 'tag' => valid_attributes(code: '') }
          response.should render_template(:edit)
        end
      end
    end
  end
end
