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
      context "with valid params" do
        it "returns http redirect" do
          post 'create', { tag: valid_attributes }
          response.should be_redirect
        end

        it 'creates a tag' do
          expect {
            post 'create', { tag: valid_attributes }
          }.to change(Tag, :count).by(1)
        end

        it 'creates a tag have author who is current user' do
          post 'create', { tag: valid_attributes }
          assigns[:tag].author.should == @user
        end
      end

      context "with invalid params" do
        it "render error message" do
          post 'create', { tag: {} }
          response.should_not be_success
        end

        it 'does not create a tag' do
          expect {
            post 'create', { tag: {} }
          }.to change(Tag, :count).by(0)
        end
      end
    end

    describe "DELETE 'destroy'" do
      it "returns http success" do
        delete 'destroy', { id: @tag.to_param }
        response.should be_redirect
      end

      it "deletes the tag" do
        expect {
          delete 'destroy', { id: @tag.to_param }
        }.to change(Tag, :count).by(-1)
      end
    end
  end
end
