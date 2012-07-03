# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/games/edit" do
  before :each do
    setup_controller_request
    @game = Fabricate(:game)
    user_sign_in
    assign(:game, @game)
  end

  it "renders sys/games/edit" do
    render
  end
end
