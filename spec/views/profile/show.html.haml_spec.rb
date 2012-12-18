# -*- coding: utf-8 -*-

require 'spec_helper'

describe "profile/show" do
  before :each do
    user_sign_in
    @target = Fabricate(:user, name: 'Target User')
    assign(:user, @target)
  end

  it "renders successfully" do
    render
    rendered.should match @target.name
  end

  describe 'following_users' do

    before :each do
      @target.follow!(@user)
      render
    end

    it 'shows following users' do
      assert_select '#following_users' do
        assert_select 'img.face', 1
      end
    end
  end

  describe 'followed_users' do

    before :each do
      @user.follow!(@target)
      render
    end

    it 'shows followed users' do
      assert_select '#followed_users' do
        assert_select 'img.face', 1
      end
    end
  end
end
