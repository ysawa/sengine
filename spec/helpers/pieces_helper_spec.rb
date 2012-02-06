# -*- coding: utf-8 -*-
#
require 'spec_helper'

describe PiecesHelper do
  describe '.convert_role_to_kanji' do
    it 'convert role name to kanji' do
      kanji = convert_role_to_kanji('fu')
      kanji.should == '歩'
      kanji = convert_role_to_kanji('kaku')
      kanji.should == '角'
    end
  end
end
