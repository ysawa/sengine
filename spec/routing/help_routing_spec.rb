# -*- coding: utf-8 -*-
#
require "spec_helper"

describe HelpController do
  describe "routing" do

    it "routes to #about" do
      get("/help/about").should route_to("help#about")
    end

    it "routes to #usage" do
      get("/help/usage").should route_to("help#usage")
    end
  end
end
