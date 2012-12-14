# -*- coding: utf-8 -*-

require 'spec_helper'

describe Tagging do
  before :each do
    class TestModel
      include Mongoid::Document
      include Tagging
    end
  end

  describe 'model.tag_ids' do
    before :each do
      @tag = Fabricate(:tag)
    end

    it 'has [] as default value' do
      model = TestModel.new
      model.tag_ids.should == []
    end

    it 'has ids of tags' do
      model = TestModel.new
      model.tag_ids = [@tag.id]
      model.save
      model.reload
      model.tag_ids.should == [@tag.id]
    end

    it 'has ids uniquely' do
      model = TestModel.new
      model.tag_ids = [@tag.id, @tag.id]
      model.save
      model.reload
      model.tag_ids.should == [@tag.id]
    end
  end

  describe 'model.tags' do
    before :each do
      @tag = Fabricate(:tag)
      @another_tag = Fabricate(:tag, code: 'another_tag')
    end

    it 'finds tags correspnded with model.tag_ids' do
      model = TestModel.new
      model.tag_ids = [@tag.id]
      model.tags.should be_a Mongoid::Criteria
      model.tags.to_a.should == [@tag]
      model.tag_ids = [@tag.id, @another_tag.id]
      model.tags.to_a.should == [@tag, @another_tag]
    end
  end
end
