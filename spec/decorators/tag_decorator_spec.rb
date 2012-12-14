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
      @decorator.name(false, 'en').should match @tag.name
      @decorator.name(false, 'ja').should be_nil
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
