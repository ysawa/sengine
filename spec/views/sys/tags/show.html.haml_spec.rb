# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/tags/show.html.haml" do

  before :each do
    @tag = Fabricate(:tag)
    assign(:tag, @tag)
  end

  it 'renders successfully' do
    render
    rendered.should match @tag.code
    rendered.should match @tag.name
    @tag.content.split(/\n/).each do |content|
      rendered.should match content
    end
  end
end
