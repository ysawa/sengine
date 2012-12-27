# -*- coding: utf-8 -*-

require 'spec_helper'

describe "pushes/index.json.json_builder" do
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
    rendered.should match("\"_id\": \"1\"")
    rendered.should match("\"persisted\": true")
    rendered.should match("2010")
    rendered.should match("\"pushable\": {")
    rendered.should match("\"_type\":\"Movement\"")
  end
end
