# -*- coding: utf-8 -*-

require 'spec_helper'

describe Visibility::Filter do

  before :each do
    class TestModel
      include Mongoid::Document
      include Visibility::Filter
    end
    @user = Fabricate(:user)
    @another = Fabricate(:user)
  end
end
