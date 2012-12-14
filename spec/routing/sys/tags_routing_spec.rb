# -*- coding: utf-8 -*-

require "spec_helper"

describe Sys::TagsController do
  describe "routing" do

    it "routes to #create" do
      post("/sys/tags").should route_to("sys/tags#create")
    end

    it "routes to #edit" do
      get("/sys/tags/tag_name/edit").should route_to("sys/tags#edit", id: 'tag_name')
    end

    it "routes to #index" do
      get("/sys/tags").should route_to("sys/tags#index")
    end

    it "routes to #new" do
      get("/sys/tags/new").should route_to("sys/tags#new")
    end

    it "routes to #show" do
      get("/sys/tags/tag_name").should route_to("sys/tags#show", id: 'tag_name')
    end

    it "routes to #update" do
      put("/sys/tags/tag_name").should route_to("sys/tags#update", id: 'tag_name')
    end
  end
end
