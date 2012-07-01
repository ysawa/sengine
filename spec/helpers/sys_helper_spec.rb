# -*- coding: utf-8 -*-

require 'spec_helper'

describe SysHelper do
  describe '.sys_site_title' do
    it 'convert argument into title string' do
      sys_site_title.should be_a String
    end
  end
end
