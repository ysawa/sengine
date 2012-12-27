# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/pushes/index.html.haml" do

  before :each do
    @push = Fabricate(:push)
    assign(:pushes, Push.all.page(1))
  end

  it 'renders successfully' do
    render
    rendered.should have_selector 'table.table'
  end

  describe 'nav.pagination' do
    before :each do
      10.times do
        @push = Fabricate(:push)
      end
      assign(:pushes, Push.all.page(1))
    end

    it "renders a pagination" do
      render
      rendered.should have_selector 'nav.pagination'
    end
  end
end
