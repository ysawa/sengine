# -*- coding: utf-8 -*-

require 'spec_helper'

describe Tag do

  before :each do
    @tag = Fabricate(:tag)
  end

  describe '.save' do
    it 'should be success' do
      # fabricating is successful
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

  describe 'Tag.find_with_code' do
    before :each do
      @tag.code = 'Code'
      @tag.save
    end

    it 'tag can be found' do
      Tag.find_with_code('Code').should == @tag
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
