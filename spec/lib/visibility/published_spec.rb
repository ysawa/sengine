# -*- coding: utf-8 -*-

require 'spec_helper'

describe Visibility::Published do

  before :each do
    class TestModel
      include Mongoid::Document
      include Visibility::Published
    end
  end

  describe '.publish' do
    it 'sets true into .published and Time.now into .published_at' do
      model = TestModel.new
      time_now = Time.now
      model.publish
      model.published.should be_true
      model.published_at.to_i.should == time_now.to_i
    end
  end

  describe '.publish!' do
    before :each do
      @model = TestModel.new
    end

    it 'sets true into .published and Time.now into .published_at' do
      time_now = Time.now
      @model.publish!
      @model.published.should be_true
      @model.published_at.to_i.should == time_now.to_i
    end

    it 'saves the model' do
      @model.publish!
      @model.should be_persisted
    end
  end

  describe '.published?' do
    before :each do
      @model = TestModel.new
    end

    it 'gets true if conditions meet' do
      time_now = Time.now
      @model.published = true
      @model.published_at = time_now
      @model.published?.should be_true
      @model.published = true
      @model.published_at = time_now - 1.month
      @model.published?.should be_true
    end

    it 'gets false if conditions do NOT meed' do
      time_now = Time.now
      @model.published = true
      @model.published_at = time_now + 1.month
      @model.published?.should be_false
      @model.published = false
      @model.published?.should be_false
      @model.published_at = time_now - 1.month
      @model.published?.should be_false
    end
  end

  describe '.unpublish' do
    it 'sets false into .published and not cancels .published_at' do
      time_now = Time.now
      model = TestModel.new
      model.published = true
      model.published_at = time_now
      model.unpublish
      model.published.should be_false
      model.published_at.to_i.should == time_now.to_i
    end
  end

  describe '.unpublish!' do
    before :each do
      @model = TestModel.new
    end

    it 'sets false into .published and not cancels .published_at' do
      time_now = Time.now
      @model.published = true
      @model.published_at = time_now
      @model.unpublish
      @model.published.should be_false
      @model.published_at.to_i.should == time_now.to_i
    end

    it 'saves the model' do
      @model.unpublish!
      @model.should be_persisted
    end
  end

  describe '.unpublished?' do
    before :each do
      @model = TestModel.new
    end

    it 'gets true if conditions meet' do
      time_now = Time.now
      @model.published = true
      @model.published_at = time_now + 1.month
      @model.unpublished?.should be_true
      @model.published = false
      @model.unpublished?.should be_true
      @model.published_at = time_now - 1.month
      @model.unpublished?.should be_true
    end

    it 'gets false if conditions do NOT meet' do
      time_now = Time.now
      @model.published = true
      @model.published_at = time_now
      @model.unpublished?.should be_false
      @model.published = true
      @model.published_at = time_now - 1.month
      @model.unpublished?.should be_false
    end
  end

  describe 'Model.published' do
    before :each do
      @published = TestModel.new
      @published.published = true
      @published.published_at = Time.now
      @published.save
      @not_published = TestModel.new
      @not_published.published = false
      @not_published.published_at = Time.now
      @not_published.save
    end

    it 'finds published models' do
      TestModel.published.should be_a Mongoid::Criteria
      TestModel.published.to_a.should == [@published]
    end
  end

  describe 'Model.unpublished' do
    before :each do
      @published = TestModel.new
      @published.published = true
      @published.published_at = Time.now
      @published.save
      @not_published = TestModel.new
      @not_published.published = false
      @not_published.published_at = Time.now
      @not_published.save
    end

    it 'finds unpublished models' do
      TestModel.unpublished.should be_a Mongoid::Criteria
      TestModel.unpublished.to_a.should == [@not_published]
    end
  end
end
