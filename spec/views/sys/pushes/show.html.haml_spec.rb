# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/pushes/show.html.haml" do

  before :each do
    @push = Fabricate(:push)
    assign(:push, @push)
  end

  it 'renders successfully' do
    render
  end
end
