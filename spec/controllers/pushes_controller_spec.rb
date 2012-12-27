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

  before :each do
    @user = Fabricate(:user)
    @push = Fabricate(:push)
  end

  context 'when NOT signed in' do
    %w(html json).each do |format|
      describe "GET 'index.#{format}'" do
        it "redirect to page for user to sign in" do
          get 'index', { format: format }
          response.should_not be_success
        end
      end
    end
  end

  context 'when signed in' do
    before :each do
      user_sign_in
    end

    %w(html json).each do |format|
      describe "GET 'index.#{format}'" do
        it "returns http success" do
          get 'index', { format: format }
          response.should be_success
        end

        it 'generates pushes' do
          get 'index', { format: format }
          assigns(:pushes).should be_a Mongoid::Criteria
          assigns(:pushes).to_a.should == [@push]
        end

        it 'generates not hidden pushes' do
          hidden_push = Fabricate.build(:push)
          hidden_push.hide_user!(@user)
          get 'index', { format: format }
          assigns(:pushes).should be_a Mongoid::Criteria
          assigns(:pushes).to_a.should == [@push]
        end
      end
    end
  end
end
