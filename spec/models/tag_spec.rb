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

  describe 'localization of' do
    describe 'name' do
      it 'name can take some locales' do
        I18n.locale = :en
        @tag.name = 'Tag name en'
        I18n.locale = :ja
        @tag.name = 'Tag name ja'
        @tag.save
        I18n.locale = :en
        @tag.name.should == 'Tag name en'
        I18n.locale = :ja
        @tag.name.should == 'Tag name ja'
      end
    end

    describe 'content' do
      it 'content can take some locales' do
        I18n.locale = :en
        @tag.content = 'Tag content en'
        I18n.locale = :ja
        @tag.content = 'Tag content ja'
        @tag.save
        I18n.locale = :en
        @tag.content.should == 'Tag content en'
        I18n.locale = :ja
        @tag.content.should == 'Tag content ja'
      end
    end
  end
end
