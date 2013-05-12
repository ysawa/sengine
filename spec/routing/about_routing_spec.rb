# -*- coding: utf-8 -*-

require "spec_helper"

describe AboutController do
  describe "routing" do

    it "routes to #privacy" do
      get("/about/privacy").should route_to("about#privacy")
    end

    it "routes to #tos" do
      get("/about/tos").should route_to("about#tos")
    end
  end
end
