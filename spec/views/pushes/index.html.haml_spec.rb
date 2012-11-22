# -*- coding: utf-8 -*-

require 'spec_helper'

describe "pushes/index" do
  before(:each) do
    user_sign_in
    assign(:pushes, [
      stub_model(Push,
        :content => "Content"
      ),
      stub_model(Push,
        :content => "Content"
      )
    ])
  end

  it "renders a list of pushes" do
    render
  end
end
