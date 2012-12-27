# -*- coding: utf-8 -*-

require "spec_helper"

describe Sys::PushesController do
  describe "routing" do

    it "routes to #create" do
      post("/sys/pushes").should route_to("sys/pushes#create")
    end

    it "routes to #destroy" do
      delete("/sys/pushes/1").should route_to("sys/pushes#destroy", id: '1')
    end

    it "routes to #edit" do
      get("/sys/pushes/1/edit").should route_to("sys/pushes#edit", id: '1')
    end

    it "routes to #index" do
      get("/sys/pushes").should route_to("sys/pushes#index")
    end

    it "routes to #new" do
      get("/sys/pushes/new").should route_to("sys/pushes#new")
    end

    it "routes to #show" do
      get("/sys/pushes/1").should route_to("sys/pushes#show", id: '1')
    end

    it "routes to #update" do
      put("/sys/pushes/1").should route_to("sys/pushes#update", id: '1')
    end
  end
end
