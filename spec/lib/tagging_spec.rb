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

    it 'has legal ids' do
      model = TestModel.new
      model.tag_ids = ['', nil, ' ', 'nil']
      model.save
      model.reload
      model.tag_ids.should == []
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

  describe 'model.tag_append' do
    before :each do
      @tag = Fabricate(:tag)
      @another_tag = Fabricate(:tag, code: 'another_tag')
      @model = TestModel.new
    end

    it 'appends tag_id to tag_ids' do
      @model.tag_append @tag
      @model.tag_ids.should == [@tag.id]
      @model.tag_append @tag
      @model.tag_ids.should == [@tag.id, @tag.id]
      @model.tag_append @tag
      @model.tag_ids.should == [@tag.id, @tag.id, @tag.id]
    end

    it 'ensures tag_id be Moped::BSON::ObjectId' do
      @model.tag_append @tag
      @model.tag_ids.should == [@tag.id]
      @model.tag_append @tag.id
      @model.tag_ids.should == [@tag.id, @tag.id]
      @model.tag_append @tag.id.to_s
      @model.tag_ids.should == [@tag.id, @tag.id, @tag.id]
    end
  end

  describe 'model.tag_delete' do
    before :each do
      @tag = Fabricate(:tag)
      @another_tag = Fabricate(:tag, code: 'another_tag')
      @model = TestModel.new
      @model.tag_ids = [@tag.id]
    end

    it 'appends tag_id to tag_ids' do
      @model.tag_delete @tag
      @model.tag_ids.should == []
    end
  end

  describe 'model.tag_name_append' do
    before :each do
      @tag = Fabricate(:tag, name: 'Tag')
      @another_tag = Fabricate(:tag, code: 'another_tag')
      @model = TestModel.new
    end

    it 'appends tag_id to tag_ids' do
      @model.tag_name_append('Tag')
      @model.tag_ids.should == [@tag.id]
      @model.tag_name_append('Tag')
      @model.tag_ids.should == [@tag.id, @tag.id]
      @model.tag_name_append('Tag')
      @model.tag_ids.should == [@tag.id, @tag.id, @tag.id]
    end

    it 'ensures newly created tag_id be Moped::BSON::ObjectId' do
      @model.tag_name_append('Teg')
      @model.tag_ids.should_not == [@tag.id]
      @model.save
      @model.tags.first.name.should == 'Teg'
    end
  end

  describe '.find_by_tag' do
    before :each do
      @tag = Fabricate(:tag)
      @another_tag = Fabricate(:tag, code: 'another_tag')
      @model = TestModel.new
      @model.tag_ids = [@tag.id]
      @model.save
    end

    it 'finds models with corresponed tags' do
      TestModel.find_by_tag(@tag).should be_a Mongoid::Criteria
      TestModel.find_by_tag(@tag).to_a.should == [@model]
      TestModel.find_by_tag(@another_tag).to_a.should == []
    end
  end

  describe '.search' do
    before :each do
      @tag = Fabricate(:tag, name: 'Goal')
      @another_tag = Fabricate(:tag, code: 'another_tag', name: 'Another')
      @model = TestModel.new
      @model.tag_ids = [@tag.id]
      @model.save
    end

    it 'finds models with corresponed tags' do
      TestModel.search('Goal').should be_a Mongoid::Criteria
      TestModel.search('Goal').to_a.should == [@model]
      TestModel.search('Another').to_a.should == []
    end
  end

  describe 'protected attributes' do
    before :each do
      @tag = Fabricate(:tag)
      @another_tag = Fabricate(:tag, code: 'another_tag')
    end

    it 'should be protected from the malicious form' do
      model = TestModel.new(tag_ids: [@tag.id, 'invalid string'])
      model.tag_ids.should be_blank
    end
  end
end
