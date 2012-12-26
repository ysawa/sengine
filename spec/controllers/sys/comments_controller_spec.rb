# -*- coding: utf-8 -*-

require 'spec_helper'

describe Sys::CommentsController do

  before :each do
    @comment = Fabricate(:comment)
    @user = Fabricate(:user, admin: true)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', { id: @comment.to_param }
      response.should be_success
    end
  end
end
