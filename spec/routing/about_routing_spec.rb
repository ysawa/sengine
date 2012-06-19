# -*- coding: utf-8 -*-

require "spec_helper"

describe AboutController do
  describe "routing" do

    it "routes to #game" do
      get("/about/game").should route_to("about#game")
    end
  end
end
