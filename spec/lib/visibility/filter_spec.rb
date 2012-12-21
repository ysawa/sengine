# -*- coding: utf-8 -*-

require 'spec_helper'

describe Visibility::Filter do

  before :each do
    class TestModel
      include Mongoid::Document
      include Visibility::Filter
    end
    @user = Fabricate(:user)
    @another = Fabricate(:user)
  end

  describe '.black_user?' do

    it 'checks if the user is black' do
      model = TestModel.new
      model.using_black_list = true
      model.black_user_ids << @user.id
      model.black_user?(@user).should be_true
      model.black_user?(@another).should be_false
    end
  end

  describe '.white_user?' do

    it 'checks if the user is white' do
      model = TestModel.new
      model.using_white_list = true
      model.white_user_ids << @user.id
      model.white_user?(@user).should be_true
      model.white_user?(@another).should be_false
    end
  end
end
