# -*- coding: utf-8 -*-
require 'spec_helper'

describe MovementDecorator do
  before :each do
    @movement = Fabricate(:movement, number: 11, from_point: [5, 5], to_point: [4, 5], role_value: Piece::FU, sente: true)
    @past_movement = Fabricate(:movement, number: 10, from_point: [5, 6], to_point: [6, 6], role_value: Piece::FU, sente: false)
    @decorator = MovementDecorator.new(@movement)
  end

  describe '.kifu_format' do
    it 'makes kifu formatted string' do
      kifu = @decorator.kifu_format
      kifu.should be_a String
    end

    it 'shows which the movement is sente or gote' do
      @movement.sente = true
      kifu = @decorator.kifu_format
      kifu.should match '▲'
      @movement.sente = false
      kifu = @decorator.kifu_format
      kifu.should match '△'
    end

    context 'moving to the same point' do
      before :each do
        @past_movement.to_point = @movement.to_point
      end

      it 'notices the movement is for the same point' do
        kifu = @decorator.kifu_format(@past_movement)
        kifu.should match '同'
      end
    end

    context 'moving to be put' do
      before :each do
        @movement.from_point = nil
        @movement.put = true
      end

      it 'notices the movement is to be put' do
        kifu = @decorator.kifu_format
        kifu.should match '打'
      end
    end

    context 'moving to be reversed' do
      before :each do
        @movement.reverse = true
      end

      it 'notices the movement is to be reversed' do
        kifu = @decorator.kifu_format
        kifu.should match '成'
      end
    end
  end
end
