# -*- coding: utf-8 -*-

require 'spec_helper'

describe Visibility::Hidden do

  before :each do
    class TestModel
      include Mongoid::Document
      include Visibility::Hidden
    end
    @user = Fabricate(:user)
    @another = Fabricate(:user)
  end

  describe '.hide_user' do
    it 'hides the model for the argument user' do
      model = TestModel.new
      model.hide_user(@user)
      model.hidden_user_ids.should include @user.id
    end
  end

  describe '.hidden?' do
    before :each do
      @model = TestModel.new
      @model.hidden_user_ids << @user.id
    end

    it 'gets true if the user is hidden' do
      @model.hidden?(@user).should be_true
    end

    it 'gets false if the user is shown' do
      @model.hidden?(@another).should be_false
    end
  end

  describe '.shown?' do
    before :each do
      @model = TestModel.new
      @model.hidden_user_ids << @user.id
    end

    it 'gets true if the user is shown' do
      @model.shown?(@another).should be_true
    end

    it 'gets false if the user is hidden' do
      @model.shown?(@user).should be_false
    end
  end

  describe 'Model.shown' do
    before :each do
      @model = TestModel.new
      @model.hidden_user_ids << @user.id
      @model.save
    end

    it 'finds models which meets conditions' do
      TestModel.shown(@user).should be_a Mongoid::Criteria
      TestModel.shown(@user).to_a.should == []
      TestModel.shown(@another).to_a.should == [@model]
    end
  end

  describe 'Model.hidden' do
    before :each do
      @model = TestModel.new
      @model.hidden_user_ids << @user.id
      @model.save
    end

    it 'finds models which meets conditions' do
      TestModel.hidden(@user).should be_a Mongoid::Criteria
      TestModel.hidden(@user).to_a.should == [@model]
      TestModel.hidden(@another).to_a.should == []
    end
  end
end
