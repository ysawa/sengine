# -*- coding: utf-8 -*-

require 'spec_helper'

describe PushesController do

  describe "GET 'index'" do
    it "returns http success if NOT requested JSON format" do
      get 'index', { format: 'html' }
      response.should_not be_success
    end

    it "returns http success if requested JSON format" do
      get 'index', { format: 'json' }
      response.should be_success
    end
  end
end
