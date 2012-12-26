# -*- coding: utf-8 -*-

require "spec_helper"

describe Sys::CommentsController do
  describe "routing" do

    it "routes to #index" do
      get("/sys/comments").should route_to("sys/comments#index")
    end

    it "routes to #show" do
      get("/sys/comments/1").should route_to("sys/comments#show", id: '1')
    end
  end
end
