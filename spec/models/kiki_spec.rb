# -*- coding: utf-8 -*-

require 'spec_helper'

describe Kiki do
  describe '.initialize' do
    it 'creates move_kikis and jump_kikis' do
      kiki = Kiki.new
      kiki.get_move_kikis(0).should == nil
      kiki.get_move_kikis(11).should be_a Array
      kiki.get_move_kikis(99).should be_a Array
      kiki.get_move_kikis(100).should == nil
      kiki.get_jump_kikis(0).should == nil
      kiki.get_jump_kikis(11).should be_a Array
      kiki.get_jump_kikis(99).should be_a Array
      kiki.get_jump_kikis(100).should == nil
    end
  end
end
