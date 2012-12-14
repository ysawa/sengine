# -*- coding: utf-8 -*-

require "spec_helper"

describe TagsController do
  describe "routing" do

    it "routes to #index" do
      get("/tags").should route_to("tags#index")
    end

    it "routes to #show" do
      get("/tags/tag_name").should route_to("tags#show", id: 'tag_name')
    end
  end
end
