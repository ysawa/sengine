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

  describe '.role_string' do
    it 'works!' do
      movement.role = Piece::FU
      movement.role_string.should == 'fu'
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
    describe '.role should be taken' do
      it 'valid if role exists' do
        movement.role = Piece::FU
        movement.valid?.should be_true
      end

      it 'invalid if role does not exists' do
        movement.role = nil
        movement.valid?.should be_false
      end
    end
  end

  describe '.to_json' do
    it 'generates JSON successfully' do
      movement.role = Piece::HI
      json_string = movement.to_json
      json_string.should match "\"hi\""
      json_string.should match "\"#{movement.id.to_s}\""
    end

    it 'generated JSON string can be parsed into hash' do
      movement.role = Piece::RY
      json_string = movement.to_json
      hash = JSON.parse json_string
      hash['role_string'].should == "ry"
      hash['_id'].should == movement.id.to_s
    end
  end
end
