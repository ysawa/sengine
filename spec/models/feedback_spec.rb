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
    it 'strip tail line feeds' do
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
end
