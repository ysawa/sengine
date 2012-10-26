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
    describe '.validate_reverse_can_be_taken' do
      it 'valid if not reverse' do
        movement.reverse = false
        movement.valid?.should be_true
      end

      it 'invalid if reverse and put' do
        movement.reverse = true
        movement.put = true
        movement.valid?.should be_false
      end
    end
    describe '.validate_move_and_put_incompatibility' do
      it 'valid if move and put are the different values' do
        movement.put = true
        movement.move = false
        movement.valid?.should be_true
        movement.put = false
        movement.move = true
        movement.valid?.should be_true
      end

      it 'valid if move and put are the different values' do
        movement.put = true
        movement.move = true
        movement.valid?.should be_false
        movement.put = false
        movement.move = false
        movement.valid?.should be_false
      end
    end
  end
end
