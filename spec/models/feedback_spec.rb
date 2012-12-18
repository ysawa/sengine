# -*- coding: utf-8 -*-

require 'spec_helper'

describe Feedback do
  before :each do
    @feedback = Fabricate(:feedback)
  end

  let :feedback do
    @feedback
  end

  describe '.save' do
    let :feedback do
      Fabricate.build(:feedback)
    end

    it 'works!' do
      feedback.save.should be_true
    end
  end

  describe '.strip_tail_line_feeds' do
    it 'strips tail line feeds' do
      feedback.content = "aaa\nbbb\nccc\n\n"
      feedback.strip_tail_line_feeds
      feedback.content.should == "aaa\nbbb\nccc"
      feedback.content = "aaa\r\nbbb\r\nccc\r\n\r\n"
      feedback.strip_tail_line_feeds
      feedback.content.should == "aaa\r\nbbb\r\nccc"
    end

    it 'is executed when saving' do
      feedback.content = "aaa\nbbb\nccc\n\n"
      feedback.save
      feedback.content.should == "aaa\nbbb\nccc"
    end
  end

  # attr_protected :dislike_user_ids, :like_user_ids, :published, :success, :author_id, :parent_id
  describe 'attr_protected' do
    before :each do
      @feedback = Fabricate(:feedback, published: false, success: false)
      @parent = Fabricate(:feedback)
      @user = Fabricate(:user)
    end

    attr_names = [:dislike_user_ids, :like_user_ids]
    attr_names.each do |attr_name|
      it "protects #{attr_name}" do
        @feedback.update_attributes({ attr_name => [@user] })
        @feedback.reload
        @feedback.read_attribute(attr_name).should_not == [@user]
      end
    end

    attr_names = [:published, :success]
    attr_names.each do |attr_name|
      it "protects #{attr_name}" do
        @feedback.update_attributes({ attr_name => true })
        @feedback.reload
        @feedback.read_attribute(attr_name).should_not == true
      end
    end

    attr_names = [:author_id]
    attr_names.each do |attr_name|
      it "protects #{attr_name}" do
        @feedback.update_attributes({ attr_name => @user.id })
        @feedback.reload
        @feedback.read_attribute(attr_name).should_not == @user.id
      end
    end

    attr_names = [:parent_id]
    attr_names.each do |attr_name|
      it "protects #{attr_name}" do
        @feedback.update_attributes({ attr_name => @parent.id })
        @feedback.reload
        @feedback.read_attribute(attr_name).should_not == @parent.id
      end
    end
  end
end
