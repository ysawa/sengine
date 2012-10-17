# -*- coding: utf-8 -*-

require 'spec_helper'

describe Hand do
  before :each do
    @example_hash = {"fu"=>4, "ky"=>0, "ke"=>0, "gi"=>1, "ki"=>2, "ka"=>0, "hi"=>1, "ou"=>0}
    @example_array = [nil, 4, 0, 0, 1, 2, 0, 1, 0]
  end
  let :hand do
    Hand.new(@example_array)
  end

  describe '.initialize' do
    it 'work with a blank argument' do
      hand = Hand.new
      hand.fu.should == 0
      hand.hi.should == 0
    end

    it 'work with arguments' do
      hand_one = Hand.new(@example_hash)
      hand_two = Hand.new(@example_array)
      Hand::KEY_NAMES.each do |key|
        value_one = hand_one.public_send(key)
        value_two = hand_two.public_send(key)
        value_one.should == value_two
      end
    end
  end

  describe '.fu' do
    it 'is accessible' do
      hand.fu.should == 4
      hand.fu = 9
      hand.fu.should == 9
      hand.fu = nil
      hand.fu.should == 0
    end
  end

  describe '.hi' do
    it 'is accessible' do
      hand.hi.should == 1
      hand.hi = 2
      hand.hi.should == 2
      hand.hi = nil
      hand.hi.should == 0
    end
  end

  describe 'can be treated like' do
    it 'Hash' do
      hand[:fu].should == 4
      hand['fu'].should == 4
      hand[:hi].should == 1
      hand['hi'].should == 1
      hand['fu'] = 6
      hand['fu'].should == 6
      hand[:hi] = 2
      hand[:hi].should == 2
    end

    it 'Array' do
      hand[0].should == nil
      hand[1].should == 4
      hand[2].should == 0
      hand[1] = 6
      hand[1].should == 6
      hand[2] = 2
      hand[2].should == 2
    end
  end

  describe '.mongoize' do
    it 'generate a hash instance for mongodb' do
      hand.mongoize.should == @example_hash
    end
  end

  describe 'Hand.mongoize' do
    it 'generate a Hash instance for MongoDB' do
      Hand.mongoize(@example_hash).should == @example_hash
      Hand.mongoize(@example_array).should == @example_hash
    end
  end
end
