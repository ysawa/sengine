# -*- coding: utf-8 -*-

require 'spec_helper'

describe Visibility::Checked do

  before :each do
    class TestModel
      include Mongoid::Document
      include Visibility::Checked
    end
    @user = Fabricate(:user)
    @another = Fabricate(:user)
  end

  describe '.check_user' do
    it 'checks the model for the argument user' do
      model = TestModel.new
      model.check_user(@user)
      model.checked_user_ids.should include @user.id
    end
  end

  describe '.check_user!' do
    it 'checks the model for the argument user' do
      model = TestModel.new
      model.check_user!(@user)
      model.checked_user_ids.should include @user.id
    end

    it 'saves the model' do
      model = TestModel.new
      model.check_user!(@user)
      model.should be_persisted
    end
  end

  describe '.checked?' do
    before :each do
      @model = TestModel.new
      @model.checked_user_ids << @user.id
    end

    it 'gets true if the user is checked' do
      @model.checked?(@user).should be_true
    end

    it 'gets false if the user is unchecked' do
      @model.checked?(@another).should be_false
    end
  end

  describe '.unchecked?' do
    before :each do
      @model = TestModel.new
      @model.checked_user_ids << @user.id
    end

    it 'gets true if the user is unchecked' do
      @model.unchecked?(@another).should be_true
    end

    it 'gets false if the user is checked' do
      @model.unchecked?(@user).should be_false
    end
  end

  describe 'Model.unchecked' do
    before :each do
      @model = TestModel.new
      @model.checked_user_ids << @user.id
      @model.save
    end

    it 'finds models which meets conditions' do
      TestModel.unchecked(@user).should be_a Mongoid::Criteria
      TestModel.unchecked(@user).to_a.should == []
      TestModel.unchecked(@another).to_a.should == [@model]
    end
  end

  describe 'Model.checked' do
    before :each do
      @model = TestModel.new
      @model.checked_user_ids << @user.id
      @model.save
    end

    it 'finds models which meets conditions' do
      TestModel.checked(@user).should be_a Mongoid::Criteria
      TestModel.checked(@user).to_a.should == [@model]
      TestModel.checked(@another).to_a.should == []
    end
  end
end
