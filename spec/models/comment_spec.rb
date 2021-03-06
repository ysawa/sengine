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

    it 'fails if has no content' do
      comment.content = ''
      comment.save.should be_false
    end
  end

  describe '.commentable' do
    before :each do
      @commentable = Fabricate(:game)
    end
    it 'takes commentable model' do
      comment.commentable = @commentable
      comment.save
      comment.reload
      comment.commentable_id.should == @commentable.id
      comment.commentable_type.should == 'Game'
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

  describe 'Comment.not_author' do
    before :each do
      @author = Fabricate(:user)
      comment.author = @author
      comment.save
      @other_comment = Fabricate(:comment)
    end

    it 'finds users who is not the author' do
      Comment.not_author(@author).should be_a Mongoid::Criteria
      Comment.not_author(@author).to_a.should == [@other_comment]
    end
  end
end
