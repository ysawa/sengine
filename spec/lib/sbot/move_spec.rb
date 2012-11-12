# -*- coding: utf-8 -*-

require 'spec_helper'

describe Sbot::Move do
  before :each do
  end

  let :move do
    Sbot::Move.new
  end

  describe '.initialize' do
    it 'works.' do
      @move = Sbot::Move.new(from_point: 43, put: false, reverse: true, sente: true, to_point: 33)
      @move.from_point.should == 43
      @move.to_point.should == 33
      @move.put?.should == false
      @move.sente?.should == true
      @move.gote?.should == false
      @move.reverse?.should == true
    end
  end
end