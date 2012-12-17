# -*- coding: utf-8 -*-

require 'spec_helper'

describe Tag do

  before :each do
    @tag = Fabricate.build(:tag)
  end

  describe '.save' do
    it 'should be success' do
      @tag.save.should be_true
    end
  end

  describe 'about localization of' do
    describe 'name' do
      before :each do
        I18n.locale = :en
        @tag.name = 'Tag name en'
        I18n.locale = :ja
        @tag.name = 'Tag name ja'
        @tag.save
      end

      it 'name can take some locales' do
        I18n.locale = :en
        @tag.name.should == 'Tag name en'
        I18n.locale = :ja
        @tag.name.should == 'Tag name ja'
      end

      it 'tags can be searched' do
        I18n.locale = :en
        Tag.where(name: 'Tag name en').first.should == @tag
        Tag.where(name: 'Tag name ja').first.should be_nil
        I18n.locale = :ja
        Tag.where(name: 'Tag name ja').first.should == @tag
        Tag.where(name: 'Tag name en').first.should be_nil
      end
    end

    describe 'content' do
      before :each do
        I18n.locale = :en
        @tag.content = 'Tag content en'
        I18n.locale = :ja
        @tag.content = 'Tag content ja'
        @tag.save
      end

      it 'content can take some locales' do
        I18n.locale = :en
        @tag.content.should == 'Tag content en'
        I18n.locale = :ja
        @tag.content.should == 'Tag content ja'
      end

      it 'tags can be searched' do
        I18n.locale = :en
        Tag.where(content: 'Tag content en').first.should == @tag
        Tag.where(content: 'Tag content ja').first.should be_nil
        I18n.locale = :ja
        Tag.where(content: 'Tag content ja').first.should == @tag
        Tag.where(content: 'Tag content en').first.should be_nil
      end
    end
  end

  describe '.code=' do
    it 'converts space into underscore' do
      @tag.code = 'tag code'
      @tag.code.should == 'tag_code'
      @tag.code = 'another　code'
      @tag.code.should == 'another_code'
    end

    it 'converts symbol into underscore' do
      @tag.code = 'tag/code'
      @tag.code.should == 'tag_code'
      @tag.code = 'another%code'
      @tag.code.should == 'another_code'
    end
  end

  describe '.generate_code_from_name' do
    before :each do
      @another_tag = Fabricate(:tag, name: 'Another Tag', code: 'Another')
    end

    it 'converts name strings into code' do
      @tag.code = nil
      @tag.name = 'Tag'
      @tag.generate_code_from_name
      @tag.code.should == 'Tag'
    end

    it 'converts name strings into code which is not duplicated' do
      @tag.code = nil
      @tag.name = 'Another'
      @tag.generate_code_from_name
      @tag.code.should == 'Another_'
      @tag.save
      next_tag = Fabricate.build(:tag, name: 'Another', code: nil)
      next_tag.generate_code_from_name
      next_tag.code.should == 'Another__'
    end
  end

  describe 'Tag.find_by_code' do
    before :each do
      @tag.code = 'Code'
      @tag.save
    end

    it 'tag can be found' do
      Tag.find_by_code('Code').should == @tag
      lambda { Tag.find_by_code('OtherCode') }.should raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end

  describe 'Tag.search' do
    before :each do
      I18n.locale = :en
      @tag.name = 'Tag Name'
      I18n.locale = :ja
      @tag.name = 'タグ 名前'
      @tag.save
      I18n.locale = :en
      @dummy_tag = Fabricate('tag', name: '123', code: 'CodeName')
    end

    it 'tag can be searched' do
      searched = Tag.search('Tag')
      searched.count.should == 1
      searched = Tag.search('Tage')
      searched.count.should == 0
      searched = Tag.search('タグ')
      searched.count.should == 1
    end

    it 'find all tags with the blank query' do
      Tag.search('').count.should == 2
      Tag.search(' ').count.should == 2
      Tag.search('　').count.should == 2
      Tag.search('\\').count.should == 2
    end
  end

  describe 'about validations of code' do
    it 'code should be taken' do
      @tag.code = ''
      @tag.valid?.should be_false
    end

    it 'the same code cannot be taken' do
      @another = Fabricate(:tag, code: 'same_code')
      @tag.code = 'same_code'
      @tag.valid?.should be_false
      @tag.code = 'other_code'
      @tag.valid?.should be_true
    end

    it 'the same code with case_insensitive cannot be taken' do
      @another = Fabricate(:tag, code: 'Same_Code')
      @tag.code = 'same_code'
      @tag.valid?.should be_false
    end
  end
end
