# -*- coding: utf-8 -*-

require 'spec_helper'

describe "home/top" do
  before :each do
  end

  it 'rendering works' do
    render template: 'home/top', layout: 'layouts/application'
  end
end
