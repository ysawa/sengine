# -*- coding: utf-8 -*-

require 'spec_helper'

describe Push do
  before :each do
    @push = Fabricate(:push)
  end

  let :push do
    @push
  end

  describe '.save' do
    let :push do
      Fabricate.build(:push)
    end

    it 'works!' do
      push.save.should be_true
    end
  end
end
