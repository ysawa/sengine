# -*- coding: utf-8 -*-

require "spec_helper"

describe Sys::GamesController do
  describe "routing" do

    it "routes to #destroy" do
      delete("/sys/games/1").should route_to("sys/games#destroy", id: '1')
    end

    it "routes to #edit" do
      get("/sys/games/1/edit").should route_to("sys/games#edit", id: '1')
    end

    it "routes to #index" do
      get("/sys/games").should route_to("sys/games#index")
    end

    it "routes to #show" do
      get("/sys/games/1").should route_to("sys/games#show", id: '1')
    end

    it "routes to #update" do
      put("/sys/games/1").should route_to("sys/games#update", id: '1')
    end
  end
end
