# -*- coding: utf-8 -*-

require "spec_helper"

describe PushesController do
  describe "routing" do

    it "routes to #hide" do
      put("/pushes/1/hide").should route_to("pushes#hide", id: '1')
    end

    it "routes to #index" do
      get("/pushes").should route_to("pushes#index")
    end
  end
end
