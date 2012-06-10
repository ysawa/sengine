# -*- coding: utf-8 -*-

require 'spec_helper'

describe "about/us.ja" do
  context 'without signing in' do
    it "renders about/us" do
      render
    end
  end

  context 'with signing in' do
    before :each do
      setup_controller_request
      user_sign_in
    end

    it "renders about/us" do
      render
    end
  end
end
