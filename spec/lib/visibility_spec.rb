# -*- coding: utf-8 -*-

require 'spec_helper'

describe Visibility do

  before :each do
    @user = Fabricate(:user)
  end

  describe '.get_user_id' do

    it 'get nil if argument is nil' do
      Visibility.get_user_id(nil).should == nil
    end

    it 'get user_id from argument' do
      Visibility.get_user_id(@user).should == @user.id
      Visibility.get_user_id(@user.id).should == @user.id
      Visibility.get_user_id(@user.id.to_s).should == @user.id
    end
  end
end
