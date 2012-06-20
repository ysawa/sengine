# -*- coding: utf-8 -*-

require 'spec_helper'

describe "help/index" do
  before :each do
    setup_controller_request
    user_sign_in
  end

  context 'when locale is en' do
    it "renders help/index" do
      render
      rendered.should match "<h3>\nAt first\n</h3>"
    end
  end

  context 'when locale is ja' do
    before :each do
    end

    it "renders help/index" do
      render partial: 'help/index.ja'
      rendered.should match "<h3>\nはじめに\n</h3>"
    end
  end
end
