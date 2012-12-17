# -*- coding: utf-8 -*-

require 'spec_helper'

describe ApplicationHelper do

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
