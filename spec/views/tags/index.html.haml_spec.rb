# -*- coding: utf-8 -*-

require 'spec_helper'

describe "tags/index.html.haml" do

  before :each do
    @tag = Fabricate(:tag)
    assign(:tags, Tag.page(1))
  end

  it 'renders successfully' do
    render
    rendered.match @tag.name
  end
end
