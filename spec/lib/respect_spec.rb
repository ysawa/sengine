# -*- coding: utf-8 -*-

require 'spec_helper'

describe Respect do

  before :each do
    @user = Fabricate(:user, name: 'User')
    @teacher = Fabricate(:user, name: 'Teacher')
    @another = Fabricate(:user, name: 'Another')
  end

  describe '.follow' do

    it 'appends user id into .following_user_ids' do
      @user.follow(@teacher)
      @user.following_user_ids.should == [@teacher.id]
    end
  end

  describe '.follow!' do
    before :each do
      @user = Fabricate.build(:user, name: 'User')
    end

    it 'appends user id into .following_user_ids' do
      @user.follow!(@teacher)
      @user.following_user_ids.should == [@teacher.id]
    end

    it 'saves after following' do
      @user.should_not be_persisted
      @user.follow!(@teacher)
      @user.should be_persisted
    end
  end

  describe '.followed?' do

    it 'checks if it is followed the user' do
      @user.following_user_ids << @teacher.id
      @user.save
      @user.followed?(@teacher).should be_false
      @user.followed?(@another).should be_false
      @teacher.followed?(@user).should be_true
      @another.followed?(@user).should be_false
    end
  end

  describe '.followed_users' do

    it 'finds followed users' do
      @user.following_user_ids << @teacher.id
      @user.save
      users = @user.followed_users
      users.should be_a Mongoid::Criteria
      users.to_a.should == []
      users = @teacher.followed_users
      users.should be_a Mongoid::Criteria
      users.to_a.should == [@user]
    end
  end

  describe '.following?' do

    it 'checks if it is following the user' do
      @user.following_user_ids << @teacher.id
      @user.save
      @user.following?(@teacher).should be_true
      @user.following?(@another).should be_false
      @teacher.following?(@user).should be_false
      @another.following?(@user).should be_false
    end
  end

  describe '.following_users' do

    it 'finds following users' do
      @user.following_user_ids << @teacher.id
      @user.save
      users = @user.following_users
      users.should be_a Mongoid::Criteria
      users.to_a.should == [@teacher]
      users = @teacher.following_users
      users.should be_a Mongoid::Criteria
      users.to_a.should == []
    end
  end

  describe '.make_following_user_ids_unique' do

    it 'makes following_user_ids not duplicated' do
      @user.following_user_ids << @teacher.id
      @user.following_user_ids << @teacher.id
      @user.following_user_ids << @another.id
      @user.make_following_user_ids_unique
      @user.following_user_ids.should == [@teacher.id, @another.id]
    end

    it 'works before saving' do
      @user.following_user_ids << @teacher.id
      @user.following_user_ids << @teacher.id
      @user.following_user_ids << @another.id
      @user.save
      @user.following_user_ids.should == [@teacher.id, @another.id]
    end
  end

  describe '.unfollow' do

    it 'appends user id into .following_user_ids' do
      @user.following_user_ids = [@teacher.id]
      @user.unfollow(@teacher)
      @user.following_user_ids.should == []
    end
  end

  describe '.unfollow!' do
    before :each do
      @user = Fabricate.build(:user, name: 'User')
    end

    it 'drops user id into .following_user_ids' do
      @user.following_user_ids = [@teacher.id]
      @user.unfollow!(@teacher)
      @user.following_user_ids.should == []
    end

    it 'saves after unfollowing' do
      @user.should_not be_persisted
      @user.unfollow!(@teacher)
      @user.should be_persisted
    end
  end
end
