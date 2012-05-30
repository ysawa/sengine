# -*- coding: utf-8 -*-

require 'spec_helper'

describe SettingController do

  context 'if NOT signed in' do
    describe "GET 'index'" do
      it "returns http redirect" do
        get 'index'
        response.should be_redirect
      end
    end
  end

  context 'if signed in' do

    before :each do
      user_sign_in
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end
  end
end
