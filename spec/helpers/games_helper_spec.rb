# -*- coding: utf-8 -*-

require 'spec_helper'

describe GamesHelper do

  describe '.convert_number_to_full' do
    it 'convert number to full width one' do
      full = convert_number_to_full(1)
      full.should == '１'
      full = convert_number_to_full(2)
      full.should == '２'
    end
  end

  describe '.convert_number_to_kanji' do
    it 'convert number to kanji' do
      kanji = convert_number_to_kanji(1)
      kanji.should == '一'
      kanji = convert_number_to_kanji(2)
      kanji.should == '二'
    end
  end
end
