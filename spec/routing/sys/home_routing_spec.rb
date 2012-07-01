# -*- coding: utf-8 -*-

require "spec_helper"

describe Sys::HomeController do
  describe "routing" do

    it "routes to #index" do
      get("/sys").should route_to("sys/home#index")
    end
  end
end
