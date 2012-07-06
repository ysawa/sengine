# -*- coding: utf-8 -*-

require 'spec_helper'

describe Feedback do
  describe '.save' do
    let :feedback do
      Fabricate.build(:feedback)
    end
    it 'works!' do
      feedback.save.should be_true
    end
  end
end
