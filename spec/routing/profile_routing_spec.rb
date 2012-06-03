# -*- coding: utf-8 -*-

require "spec_helper"

describe ProfileController do
  describe "routing" do

    it "routes to #show" do
      get("/profile/1").should route_to("profile#show", id: '1')
    end
  end
end
