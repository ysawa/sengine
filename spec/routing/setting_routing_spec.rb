# -*- coding: utf-8 -*-

require "spec_helper"

describe SettingController do
  describe "routing" do

    it "routes to #index" do
      get("/setting").should route_to("setting#index")
    end
  end
end
