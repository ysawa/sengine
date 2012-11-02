# -*- coding: utf-8 -*-

require 'spec_helper'

describe Movement do
  let :movement do
    Fabricate.build(:movement)
  end

  describe '.save' do
    it 'works!' do
      movement.save.should be_true
    end
  end

  describe '.role' do
    it 'works!' do
      movement.role_value = Piece::FU
      movement.role.should == 'fu'
    end
  end

  describe '.move and .move?' do
    it 'means not put' do
      movement.put = false
      movement.move.should be_true
      movement.put = true
      movement.move.should be_false
    end

    it 'means not put?' do
      movement.put = false
      movement.move?.should be_true
      movement.put = true
      movement.move?.should be_false
    end
  end

  describe 'validtations' do
    describe '.to_point should be taken' do
      it 'valid if to_point exist' do
        movement.to_point = [1, 2]
        movement.valid?.should be_true
      end

      it 'invalid if to_point not exist' do
        movement.to_point = nil
        movement.valid?.should be_false
      end
    end
    describe '.from_point should be taken' do
      it 'valid if moving and from_point exist' do
        movement.from_point = [1, 2]
        movement.valid?.should be_true
      end

      it 'invalid if moving and from_point not exist' do
        movement.from_point = nil
        movement.put = false
        movement.valid?.should be_false
      end

      it 'invalid if not moving and from_point not exist' do
        movement.from_point = [1, 2]
        movement.put = true
        movement.valid?.should be_false
      end
    end
    describe '.validate_reverse_can_be_taken' do
      it 'valid if not reverse' do
        movement.reverse = false
        movement.valid?.should be_true
      end

      it 'invalid if reverse and put' do
        movement.reverse = true
        movement.put = true
        movement.valid?.should be_false
        movement.errors.size.should == 2
        movement.from_point = nil
        movement.valid?.should be_false
        movement.errors.size.should == 1
      end
    end
  end
end
