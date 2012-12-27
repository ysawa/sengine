# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/pushes/edit.html.haml" do
  before :each do
    @push = Fabricate(:push)
    assign(:push, @push)
  end

  it 'renders successfully' do
    render
    rendered.should have_selector 'form.edit_push'
  end
end
