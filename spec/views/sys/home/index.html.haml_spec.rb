# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/home/index" do
  before :each do
  end

  it "renders sys/home/index" do
    render template: 'sys/home/index', layout: 'layouts/sys/application'
  end

  it "renders menu" do
    render template: 'sys/home/index', layout: 'layouts/sys/application'
    rendered.should have_selector 'a[href="/sys/users"]'
    rendered.should have_selector 'a[href="/sys/games"]'
    rendered.should have_selector 'a[href="/sys/feedbacks"]'
    rendered.should have_selector 'a[href="/sys/tags"]'
    rendered.should have_selector 'a[href="/sys/users"]'
  end
end
