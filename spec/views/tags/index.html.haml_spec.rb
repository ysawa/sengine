# -*- coding: utf-8 -*-

require 'spec_helper'

describe "tags/index.html.haml" do

  before :each do
    @tag = Fabricate(:tag)
  end

  it 'renders successfully' do
    render
  end
end
