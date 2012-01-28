# -*- coding: utf-8 -*-

require "spec_helper"

describe AudioController do
  describe "routing" do

    it "routes to #encode" do
      get("/audio/encode/put.mp3").should route_to("audio#encode", filename: 'put', format: 'mp3')
    end
  end
end
