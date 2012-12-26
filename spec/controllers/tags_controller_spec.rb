# -*- coding: utf-8 -*-

require 'spec_helper'

describe TagsController do

  def valid_attributes(attributes = {})
    attrs = { code: 'TestTag' }
    attrs.merge(attributes)
  end

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

    describe "GET 'show'" do
      it "returns http redirect" do
        get 'show', { id: @tag.to_param }
        response.should be_redirect
      end
    end

    describe "GET 'search'" do
      it "returns http redirect" do
        get 'search', q: 'tag'
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

    describe "POST 'create'" do
      it "returns http redirect" do
        post 'create', { tag: valid_attributes }
        response.should be_redirect
      end

      it 'creates a tag' do
        expect {
          post 'create', { tag: valid_attributes }
        }.to change(Tag, :count).by(1)
      end

      it "render index" do
        post 'create', { tag: {} }
        response.should render_template('index')
      end
    end
  end
end
