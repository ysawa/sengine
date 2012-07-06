# -*- coding: utf-8 -*-

require "spec_helper"

describe FeedbacksController do
  describe "routing" do

    it "routes to #create" do
      post("/feedbacks").should route_to("feedbacks#create")
    end

    it "routes to #index" do
      get("/feedbacks").should route_to("feedbacks#index")
    end

    it "routes to #show" do
      get("/feedbacks/1").should route_to("feedbacks#show", :id => "1")
    end
  end
end
