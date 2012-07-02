# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/home/index" do
  it "renders sys/home/index" do
    render template: 'sys/home/index', layout: 'layouts/sys/application'
  end
end
