# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/tags/show.html.haml" do

  before :each do
    @tag = Fabricate(:tag)
    assign(:tag, @tag)
  end

  it 'renders successfully' do
    render
    rendered.should match @tag.name
  end
end
