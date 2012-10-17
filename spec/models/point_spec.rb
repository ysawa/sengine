# -*- coding: utf-8 -*-

require 'spec_helper'

describe Point do
  let :point do
    Point.new(4, 5)
  end

  describe '.x' do
    it 'is accessible' do
      point.x.should == 4
      point.x = 9
      point.x.should == 9
    end
  end

  describe '.y' do
    it 'is accessible' do
      point.y.should == 5
      point.y = 9
      point.y.should == 9
    end
  end

  describe 'can be treated like' do
    it 'Hash' do
      point[:x].should == 4
      point['x'].should == 4
      point[:y].should == 5
      point['y'].should == 5
      point['x'] = 6
      point['x'].should == 6
      point[:y] = 7
      point[:y].should == 7
    end

    it 'Array' do
      point[0].should == 4
      point[1].should == 5
      point[0] = 6
      point[0].should == 6
      point[1] = 7
      point[1].should == 7
    end
  end

  describe '.mongoize' do
    it 'generate a Hash instance for MongoDB' do
      point.mongoize.should == { 'x' => 4, 'y' => 5 }
    end
  end

  describe 'Point.mongoize' do
    it 'generate a Hash instance for MongoDB' do
      Point.mongoize({ 'x' => 9, 'y' => 3 }).should == { 'x' => 9, 'y' => 3 }
      Point.mongoize({ 'x' => '9', 'y' => '3' }).should == { 'x' => 9, 'y' => 3 }
      Point.mongoize({ x: 9, y: 3 }).should == { 'x' => 9, 'y' => 3 }
      Point.mongoize({ x: '9', y: '3' }).should == { 'x' => 9, 'y' => 3 }
      Point.mongoize([9, 3]).should == { 'x' => 9, 'y' => 3 }
      Point.mongoize(['9', '3']).should == { 'x' => 9, 'y' => 3 }
    end
  end
end
