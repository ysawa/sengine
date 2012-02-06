# -*- coding: utf-8 -*-

require 'spec_helper'

describe GamesHelper do
  describe '.convert_number_to_kanji' do
    it 'convert number to kanji' do
      kanji = convert_number_to_kanji(1)
      kanji.should == '一'
      kanji = convert_number_to_kanji(2)
      kanji.should == '二'
    end
  end
end
