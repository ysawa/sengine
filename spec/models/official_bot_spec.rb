# -*- coding: utf-8 -*-

require 'spec_helper'

describe OfficialBot do
  let :bot do
    Fabricate.build(:official_bot)
  end

  describe '.bot?' do
    it 'should be true' do
      bot.should be_true
    end
  end
end
