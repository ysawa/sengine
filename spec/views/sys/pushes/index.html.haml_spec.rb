# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/pushes/index.html.haml" do

  before :each do
    @push = Fabricate(:push)
    assign(:pushes, Push.all.page(1))
  end

  it 'renders successfully' do
    render
    rendered.should have_selector 'table.table'
  end
end
