# -*- coding: utf-8 -*-

require 'spec_helper'

describe "games/new" do
  before(:each) do
    user_sign_in
    assign(:game, stub_model(Game).as_new_record)
    assign(:friends, User.all)
  end

  it "renders new game form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: games_path, method: "post" do
    end
  end
end
