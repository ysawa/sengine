# -*- coding: utf-8 -*-

require "spec_helper"

describe Sys::FeedbacksController do
  describe "routing" do

    it "routes to #create" do
      post("/sys/feedbacks").should route_to("sys/feedbacks#create")
    end

    it "routes to #destroy" do
      delete("/sys/feedbacks/1").should route_to("sys/feedbacks#destroy", id: '1')
    end

    it "routes to #edit" do
      get("/sys/feedbacks/1/edit").should route_to("sys/feedbacks#edit", id: '1')
    end

    it "routes to #index" do
      get("/sys/feedbacks").should route_to("sys/feedbacks#index")
    end

    it "routes to #new" do
      get("/sys/feedbacks/new").should route_to("sys/feedbacks#new")
    end

    it "routes to #show" do
      get("/sys/feedbacks/1").should route_to("sys/feedbacks#show", id: '1')
    end

    it "routes to #update" do
      put("/sys/feedbacks/1").should route_to("sys/feedbacks#update", id: '1')
    end
  end
end
