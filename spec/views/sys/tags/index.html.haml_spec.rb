# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/tags/index.html.haml" do

  before :each do
    @tag = Fabricate(:tag)
    assign(:tags, Tag.all.page(1))
  end

  it 'renders successfully' do
    render
  end
end
