# -*- coding: utf-8 -*-

require 'spec_helper'
require 'shogi_bot'

describe ShogiBot::Movement do
  before :each do
  end

  let :movement do
    ShogiBot::Movement.new
  end

  describe '.initialize' do
    it 'works.' do
      @movement = ShogiBot::Movement.new(from_point: 43, put: false, reverse: true, sente: true, to_point: 33)
      @movement.from_point.should == 43
      @movement.to_point.should == 33
      @movement.put?.should == false
      @movement.sente?.should == true
      @movement.gote?.should == false
      @movement.reverse?.should == true
    end
  end
end
