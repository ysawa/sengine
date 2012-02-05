# -*- coding: utf-8 -*-

require "spec_helper"

describe MovementsController do
  describe "routing" do

    it "routes to #create" do
      post("/games/1/movements").should route_to("movements#create", game_id: '1')
    end
  end
end
