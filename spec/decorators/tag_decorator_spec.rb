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
  end

  describe '.content' do
    it 'generates content string' do
      @tag.content.split("\n").each do |line|
        @decorator.content.should match line
      end
    end
  end
end
