# -*- coding: utf-8 -*-

require 'spec_helper'

describe UsersHelper do
  describe '.stringify_grade' do
    it 'convert grade number to grade string' do
      stringify_grade(0).should == '16 Kyu'
      stringify_grade(1).should == '15 Kyu'
      stringify_grade(16).should == '1 Dan'
    end
  end
end
