# -*- coding: utf-8 -*-

require "spec_helper"

describe SettingController do
  describe "routing" do

    it "routes to #edit" do
      get("/setting/edit").should route_to("setting#edit")
    end

    it "routes to #edit_default" do
      get("/setting/edit/default").should route_to("setting#edit", objective: 'default')
    end

    it "routes to #edit_system" do
      get("/setting/edit/system").should route_to("setting#edit", objective: 'system')
    end

    it "routes to #show" do
      get("/setting").should route_to("setting#show")
    end

    it "routes to #update" do
      put("/setting").should route_to("setting#update")
    end
  end
end
