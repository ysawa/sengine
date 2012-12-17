# -*- coding: utf-8 -*-

require 'spec_helper'

describe "tags/_search.html.haml" do

  before :each do
    @tag = Fabricate(:tag)
    assign(:tags, Tag.page(1))
  end

  it 'renders successfully' do
    render
    rendered.should have_selector 'form#search_tag'
    rendered.should have_selector 'input[name="q"]'
  end
end
