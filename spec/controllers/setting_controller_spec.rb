# -*- coding: utf-8 -*-

require 'spec_helper'

describe SettingController do

  context 'if NOT signed in' do
    describe "GET 'show'" do
      it "returns http redirect" do
        get 'show'
        response.should be_redirect
      end
    end

    describe "GET 'edit'" do
      it "returns http redirect" do
        get 'edit'
        response.should be_redirect
      end
    end

    describe "PUT 'update'" do
      it "returns http redirect" do
        put 'update'
        response.should be_redirect
      end
    end
  end

  context 'if signed in' do

    before :each do
      user_sign_in
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should be_success
      end
    end

    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit'
        response.should be_success
      end
    end

    describe "PUT 'update'" do
      it "returns http redirect" do
        put 'update', {}
        response.should be_redirect
      end
    end
  end
end
