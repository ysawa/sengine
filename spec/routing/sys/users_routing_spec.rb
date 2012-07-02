# -*- coding: utf-8 -*-

require "spec_helper"

describe Sys::UsersController do
  describe "routing" do

    it "routes to #destroy" do
      delete("/sys/users/1").should route_to("sys/users#destroy", id: '1')
    end

    it "routes to #edit" do
      get("/sys/users/1/edit").should route_to("sys/users#edit", id: '1')
    end

    it "routes to #index" do
      get("/sys/users").should route_to("sys/users#index")
    end

    it "routes to #set_admin" do
      put("/sys/users/1/set_admin").should route_to("sys/users#set_admin", id: '1')
    end

    it "routes to #show" do
      get("/sys/users/1").should route_to("sys/users#show", id: '1')
    end

    it "routes to #unset_admin" do
      put("/sys/users/1/unset_admin").should route_to("sys/users#unset_admin", id: '1')
    end

    it "routes to #update" do
      put("/sys/users/1").should route_to("sys/users#update", id: '1')
    end
  end
end
