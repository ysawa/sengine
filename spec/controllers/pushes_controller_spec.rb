# -*- coding: utf-8 -*-

require 'spec_helper'

describe PushesController do

  def valid_attributes
    {}
  end

  def valid_session
    {}
  end

  let :push do
    Fabricate(:push)
  end

  context 'when NOT signed in' do
    describe "GET 'index'" do
      it "redirect to page for user to sign in" do
        get 'index', { format: 'json' }
        response.should_not be_success
      end
    end
  end

  context 'when signed in' do
    before :each do
      user_sign_in
    end

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
end
