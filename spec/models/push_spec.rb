# -*- coding: utf-8 -*-

require 'spec_helper'

describe Push do
  before :each do
    @push = Fabricate(:push)
  end

  let :push do
    @push
  end

  let :user do
    Fabricate(:user)
  end

  describe '.save' do
    let :push do
      Fabricate.build(:push)
    end

    it 'works!' do
      push.save.should be_true
    end
  end

  describe '.hidden?' do
    it 'tells whether the push is hidden' do
      @push.hidden?(user).should == false
      @push.hidden_user_ids << user.id
      @push.hidden?(user).should == true
    end
  end

  describe '.shown?' do
    it 'tells whether the push is shown' do
      @push.shown?(user).should == true
      @push.hidden_user_ids << user.id
      @push.shown?(user).should == false
    end
  end

  describe '.hide_user' do
    it 'hides the push for the user' do
      Push.shown(user).count.should == 1
      @push.hide_user(user)
      @push.save
      Push.shown(user).count.should == 0
      Push.hidden(user).count.should == 1
    end

    it 'hides the push for two users' do
      another_user = Fabricate(:user)
      @push.hide_user(user)
      @push.hide_user(another_user)
      @push.save
      Push.shown(user).count.should == 0
      Push.hidden(user).count.should == 1
    end
  end
end
