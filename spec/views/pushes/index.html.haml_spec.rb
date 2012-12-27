# -*- coding: utf-8 -*-

require 'spec_helper'

describe "pushes/index.html.haml" do
  before(:each) do
    user_sign_in
    assign(:pushes, [
      stub_model(Push,
        _id: "1"
      ),
      stub_model(Push,
        _id: "2",
        created_at: Time.parse('2010/02/20'),
        pushable: Fabricate(:movement)
      )
    ])
  end

  it "renders a list of pushes" do
    render
  end
end
