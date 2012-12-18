# -*- coding: utf-8 -*-

require 'spec_helper'

describe Respect do

  before :each do
    @user = Fabricate(:user, name: 'User')
    @another = Fabricate(:user, name: 'Another')
  end

  describe '.followed_users' do

    it 'find followed users' do
      @user.following_user_ids << @another.id
      @user.save
      users = @user.followed_users
      users.should be_a Mongoid::Criteria
      users.to_a.should == []
      users = @another.followed_users
      users.should be_a Mongoid::Criteria
      users.to_a.should == [@user]
    end
  end

  describe '.following_users' do

    it 'find following users' do
      @user.following_user_ids << @another.id
      @user.save
      users = @user.following_users
      users.should be_a Mongoid::Criteria
      users.to_a.should == [@another]
      users = @another.following_users
      users.should be_a Mongoid::Criteria
      users.to_a.should == []
    end
  end
end
