# -*- coding: utf-8 -*-

require 'spec_helper'

describe "help/index" do
  before :each do
    user_sign_in
  end

  context 'when locale is en' do
    before :each do
      I18n.locale = :en
    end

    it "renders help/index" do
      render
      rendered.should match "<h3>\nAt first\n</h3>"
    end
  end
end
