# -*- coding: utf-8 -*-

require "spec_helper"

describe PushesController do
  describe "routing" do

    it "routes to #index" do
      get("/pushes").should route_to("pushes#index")
    end
  end
end
