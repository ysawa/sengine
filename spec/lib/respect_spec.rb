# -*- coding: utf-8 -*-

require 'spec_helper'

describe Respect do

  before :each do
    @user = Fabricate(:user, name: 'User')
    @teacher = Fabricate(:user, name: 'Teacher')
    @another = Fabricate(:user, name: 'Another')
  end

  describe '.follow' do

    it 'append user id into .following_user_ids' do
      @user.follow(@teacher)
      @user.following_user_ids.should == [@teacher.id]
    end
  end

  describe '.follow!' do
    before :each do
      @user = Fabricate.build(:user, name: 'User')
    end

    it 'append user id into .following_user_ids' do
      @user.follow!(@teacher)
      @user.following_user_ids.should == [@teacher.id]
    end

    it 'save after following' do
      @user.should_not be_persisted
      @user.follow!(@teacher)
      @user.should be_persisted
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
end
