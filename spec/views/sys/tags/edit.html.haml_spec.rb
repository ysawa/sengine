# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/tags/edit.html.haml" do
  before :each do
    @tag = Fabricate(:tag)
    assign(:tag, @tag)
  end

  it 'renders successfully' do
    render
    rendered.should have_selector 'form.edit_tag'
  end
end
