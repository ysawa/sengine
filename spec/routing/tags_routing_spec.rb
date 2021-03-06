# -*- coding: utf-8 -*-

require "spec_helper"

describe TagsController do
  describe "routing" do

    it "routes to #create" do
      post("/tags").should route_to("tags#create")
    end

    it "routes to #destroy" do
      delete("/tags/1").should route_to("tags#destroy", id: '1')
    end

    it "routes to #index" do
      get("/tags").should route_to("tags#index")
    end

    it "routes to #show" do
      get("/tags/tag_name").should route_to("tags#show", id: 'tag_name')
    end

    it "routes to #search statically" do
      get("/tags/search/somequery").should route_to("tags#search", q: 'somequery')
    end

    it "routes to #search dynamically" do
      get("/tags/search").should route_to("tags#search")
    end
  end
end
