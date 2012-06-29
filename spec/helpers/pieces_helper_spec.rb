# -*- coding: utf-8 -*-

require 'spec_helper'

describe PiecesHelper do
  describe '.convert_piece_role_to_kanji' do
    it 'convert role name of piece to kanji' do
      kanji = convert_piece_role_to_kanji('fu')
      kanji.should == '歩'
      kanji = convert_piece_role_to_kanji('ka')
      kanji.should == '角'
    end
  end
end
