# -*- coding: utf-8 -*-

require 'spec_helper'

describe "pushes/index.html.haml" do
  before(:each) do
    user_sign_in
    @push = Fabricate(:push)
    assign(:pushes, Push.all.page)
  end

  it "renders a list of pushes" do
    render
    rendered.should have_content @push.content
  end

  describe 'nav.pagination' do
    it "renders a pagination" do
      render
      rendered.should have_selector 'nav.pagination'
    end
  end
end
