# -*- coding: utf-8 -*-

require 'spec_helper'

describe ApplicationHelper do

  describe '.page_name' do

    it 'generates page name' do
      page_name('home', 'mypage').should == I18n.t('pages.controllers.home.mypage')
      page_name('tags', 'index').should == I18n.t('pages.controllers.tags.index')
    end
  end

  describe '.site_title' do

    context 'with blank argument' do
      it 'generates only the site title' do
        site_title.should == I18n.t('site.title')
      end
    end

    context 'with string argument' do
      it 'generates string included with the same string' do
        title = site_title('Subtitle')
        title.should match 'Subtitle'
        title.should match I18n.t('site.title')
      end
    end

    context 'with array argument' do
      it 'generates string included with the same array' do
        title = site_title(['Subtitle1', 'Subtitle2'])
        title.should match 'Subtitle1'
        title.should match 'Subtitle2'
        title.should match I18n.t('site.title')
      end
    end
  end

  describe '.site_title_elements' do

    context 'with blank argument' do
      it 'generates array included with site title' do
        site_title_elements.should == [I18n.t('site.title')]
      end
    end

    context 'with string argument' do
      it 'generates array included with the same string' do
        site_title_elements('Subtitle').should include 'Subtitle'
        site_title_elements.should include I18n.t('site.title')
      end
    end

    context 'with array argument' do
      it 'generates array included with the same array' do
        elements = site_title_elements(['Subtitle1', 'Subtitle2'])
        elements.should include 'Subtitle1'
        elements.should include 'Subtitle2'
        elements.should include I18n.t('site.title')
      end
    end

    context 'with user argument' do
      before :each do
        @user = Fabricate(:user)
      end

      it 'generates array included with the user name' do
        elements = site_title_elements(@user)
        elements.should include @user.name
        elements.should include I18n.t('site.title')
      end
    end

    context 'with tag argument' do
      before :each do
        @tag = Fabricate(:tag)
      end

      it 'generates array included with the tag name' do
        elements = site_title_elements(@tag)
        elements.should include @tag.name
        elements.should include I18n.t('site.title')
      end
    end
  end
end
