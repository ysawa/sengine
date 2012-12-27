# -*- coding: utf-8 -*-

require 'spec_helper'

describe PushesController do

  def valid_attributes(attributes)
    attrs = { 'content' => 'Push Content' }
    attrs.merge attributes.stringify_keys
  end

  def valid_session
    {}
  end

  let :push do
    Fabricate(:push)
  end

  context 'when NOT signed in' do
    describe "GET 'index.html'" do
      it "redirect to page for user to sign in" do
        get 'index', { format: 'html' }
        response.should_not be_success
      end
    end

    describe "GET 'index.json'" do
      it "redirect to page for user to sign in" do
        get 'index', { format: 'json' }
        response.should_not be_success
      end
    end
  end

  context 'when signed in' do
    before :each do
      user_sign_in
    end

    describe "GET 'index.html'" do
      it "returns http success" do
        get 'index', { format: 'html' }
        response.should be_success
      end

      it 'generates pushes' do
        assigns(:pushes).should be_a Mongoid::Criteria
        assigns(:pushes).to_a.should == [push]
      end
    end

    describe "GET 'index.json'" do
      it "returns http success" do
        get 'index', { format: 'json' }
        response.should be_success
      end
    end
  end
end
