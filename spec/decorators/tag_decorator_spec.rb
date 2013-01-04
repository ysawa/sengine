# -*- coding: utf-8 -*-

require 'spec_helper'

describe TagDecorator do

  before :each do
    @tag = Fabricate(:tag)
    @decorator = TagDecorator.new(@tag)
  end

  describe '.name' do
    it 'generates name string' do
      @decorator.name.should == @tag.name
    end

    it 'generates name link' do
      @decorator.name(true).should match @tag.name
      @decorator.name(true).should match '<a href='
    end

    it 'generates name of selected locale' do
      @decorator.name(false, 'en').should == @tag.name
    end

    it 'is forced to show some name of another locale if name of locale does not exist' do
      @tag.name_translations = { 'en' => 'tag name' }
      @decorator.name(false, 'en').should == 'tag name'
      @decorator.name(false, 'ja').should == 'tag name'
    end

    it 'is forced to be shown as untitled if name is completely blank' do
      @tag.name_translations = {}
      @decorator.name(false, 'en').should == 'untitled'
      @decorator.name(false, 'ja').should == 'untitled'
    end
  end

  describe '.image' do
    before :each do
      @file = File.open(File.join(Rails.root, '/app/assets/images/rails.png'))
    end

    it 'generates no img tag if tag does not have any image' do
      @decorator.image.should be_blank
    end

    it 'generates img tag if tag has an image' do
      @tag.image = @file
      @decorator.image.should match "<img"
    end

    it 'generates img tag included in a tag if tag has an image' do
      @tag.image = @file
      @decorator.image(true).should match "<a href"
      @decorator.image(true).should match "<img"
    end
  end

  describe '.content' do
    it 'generates content string' do
      @tag.content.split("\n").each do |line|
        @decorator.content.should match line
      end
    end

    it 'generates content of selected locale' do
      @decorator.content('en').should match @tag.content.split("\n").first
      @decorator.content('ja').should be_nil
    end
  end
end
