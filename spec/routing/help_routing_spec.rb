# -*- coding: utf-8 -*-
#
require "spec_helper"

describe HelpController do
  describe "routing" do

    it "routes to #index" do
      get("/help").should route_to("help#index")
    end
  end
end
