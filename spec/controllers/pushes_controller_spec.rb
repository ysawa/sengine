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

      describe "PUT 'hide.#{format}'" do
        it "redirect to page for user to sign in" do
          put 'hide', { format: format, id: @push.to_param }
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

      describe "PUT 'hide.#{format}'" do

        it 'hides the push' do
          @push.hidden?(@user).should be_false
          put 'hide', { format: format, id: @push.to_param }
          @push.reload
          @push.hidden?(@user).should be_true
        end
      end
    end

    describe "PUT 'hide.html'" do
      let :format do
        'html'
      end

      it 'redirects to pushes path' do
        put 'hide', { format: format, id: @push.to_param }
        response.should redirect_to pushes_path
      end
    end

    describe "PUT 'hide.json'" do
      let :format do
        'json'
      end

      it 'renders nothing' do
        put 'hide', { format: format, id: @push.to_param }
        response.body.should be_blank
      end
    end
  end
end
