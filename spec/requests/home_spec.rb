# -*- coding: utf-8 -*-

require 'spec_helper'

describe "Home", type: :request do
  describe "index (without signed in)" do
    it "works!" do
      get root_path
      response.status.should be(200)
    end
  end
end
