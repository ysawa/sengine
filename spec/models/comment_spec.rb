# -*- coding: utf-8 -*-

require 'spec_helper'

describe Comment do
  before :each do
    @comment = Fabricate(:comment)
  end

  let :comment do
    @comment
  end

  describe '.save' do
    let :comment do
      Fabricate.build(:comment)
    end

    it 'works!' do
      comment.save.should be_true
    end
  end

  describe '.commentable' do
    before :each do
      @commentable = Fabricate(:game)
    end
    it 'takes commentable model' do
      comment.commentable = @commentable
      comment.save
      comment.commentable_id.should == @commentable.id
      comment.commentable_type.should == @commentable._type
    end
  end

  describe '.strip_tail_line_feeds' do
    it 'strips tail line feeds' do
      comment.content = "aaa\nbbb\nccc\n\n"
      comment.strip_tail_line_feeds
      comment.content.should == "aaa\nbbb\nccc"
      comment.content = "aaa\r\nbbb\r\nccc\r\n\r\n"
      comment.strip_tail_line_feeds
      comment.content.should == "aaa\r\nbbb\r\nccc"
    end

    it 'is executed when saving' do
      comment.content = "aaa\nbbb\nccc\n\n"
      comment.save
      comment.content.should == "aaa\nbbb\nccc"
    end
  end
end
