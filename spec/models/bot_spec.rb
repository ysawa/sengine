# -*- coding: utf-8 -*-

require 'spec_helper'

describe Bot do
  let :bot do
    Fabricate.build(:bot)
  end

  describe '.bot?' do
    it 'should be true' do
      bot.should be_true
    end
  end
end
