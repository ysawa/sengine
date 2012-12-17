# -*- coding: utf-8 -*-

require 'spec_helper'

describe "tags/index.html.haml" do

  before :each do
    @tag = Fabricate(:tag)
    assign(:tags, Tag.page(1))
  end

  it 'renders successfully' do
    render
    rendered.should match @tag.name
  end

  describe 'form#search_tag' do
    before :each do
      view.stub!(:params).and_return({ q: 'Key Word' })
    end

    it 'renders successfully' do
      render
      rendered.should match 'Key Word'
    end
  end
end
