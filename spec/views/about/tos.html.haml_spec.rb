#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'spec_helper'

describe "about/tos" do
  before :each do
    setup_controller_request
  end

  it "renders about/tos to notice terms of service" do
    render
  end
end
