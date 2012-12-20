# -*- coding: utf-8 -*-

require 'spec_helper'

describe Visibility::Shown do

  before :each do
    class TestModel
      include Mongoid::Document
      include Visibility::Shown
    end
    @user = Fabricate(:user)
  end

  describe '.hide_user' do
    it 'hides the model for the argument user' do
      model = TestModel.new
      model.hide_user(@user)
      model.hidden_user_ids.should include @user.id
    end
  end
end
