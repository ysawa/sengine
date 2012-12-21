# -*- coding: utf-8 -*-

require 'spec_helper'

describe Visibility::Filter do

  before :each do
    class TestModel
      include Mongoid::Document
      include Visibility::Filter
    end
    @user = Fabricate(:user)
    @admin = Fabricate(:user)
    @not_admin = Fabricate(:user)
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

  describe '.use_black_list' do

    it 'sets .using_black_list true' do
      model = TestModel.new
      model.using_black_list.should == false
      model.use_black_list
      model.using_black_list.should == true
    end
  end

  describe '.use_black_list!' do

    it 'sets .using_black_list true' do
      model = TestModel.new
      model.using_black_list.should == false
      model.use_black_list!
      model.using_black_list.should == true
    end

    it 'saves the model' do
      model = TestModel.new
      model.use_black_list!
      model.should be_persisted
    end
  end

  describe '.use_white_list' do

    it 'sets .using_white_list true' do
      model = TestModel.new
      model.using_white_list.should == false
      model.use_white_list
      model.using_white_list.should == true
    end
  end

  describe '.use_white_list' do

    it 'sets .using_white_list true' do
      model = TestModel.new
      model.using_white_list.should == false
      model.use_white_list!
      model.using_white_list.should == true
    end

    it 'saves the model' do
      model = TestModel.new
      model.use_white_list!
      model.should be_persisted
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

  describe 'Model.visible' do
    before :each do
      @white = TestModel.new
      @white.using_white_list = true
      @white.white_user_ids << @user.id
      @white.white_user_ids << @admin.id
      @white.save
      @black = TestModel.new
      @black.using_black_list = true
      @black.black_user_ids << @user.id
      @black.black_user_ids << @not_admin.id
      @black.save
    end

    it 'finds visible models' do
      TestModel.visible(@user).should be_a Mongoid::Criteria
      TestModel.visible(@user).to_a.should == [@white]
      TestModel.visible(@admin).to_a.should == [@white, @black]
      TestModel.visible(@not_admin).to_a.should == []
      TestModel.visible(@another).to_a.should == [@black]
    end
  end
end
