# -*- coding: utf-8 -*-

require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the GamesHelper. For example:
#
# describe GamesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
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
