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

  describe 'ul#tags' do
    before :each do
      Tag.delete_all
      10.times do |i|
        Fabricate(:tag, name: "Tag #{i}", code: "tag_#{i}")
      end
      assign(:tags, Tag.page(1))
    end

    it 'contains tags' do
      render
      rendered.should have_selector 'ul#tags'
      assert_select 'ul#tags' do
        assert_select 'li.tag', 10
      end
    end
  end

  describe 'nav.pagination' do
    before :each do
      Tag.delete_all
      10.times do |i|
        Fabricate(:tag, name: "Tag #{i}", code: "tag_#{i}")
      end
    end

    it 'contains disabled pagination' do
      assign(:tags, Tag.page(1))
      render
      rendered.should have_selector 'nav.pagination'
      rendered.should have_selector 'nav.pagination span.disabled'
    end

    it 'contains enabled pagination' do
      10.times do |i|
        Fabricate(:tag, name: "Tag #{i + 10}", code: "tag_#{i + 10}")
      end
      assign(:tags, Tag.page(1))
      render
      rendered.should have_selector 'nav.pagination'
      rendered.should have_selector 'nav.pagination a'
    end
  end

  describe 'form#search_tag' do
    before :each do
      view.stub!(:params).and_return({ q: 'Key Word' })
    end

    it 'contains search field' do
      render
      rendered.should have_selector 'form#search_tag'
      rendered.should match 'Key Word'
    end
  end
end
