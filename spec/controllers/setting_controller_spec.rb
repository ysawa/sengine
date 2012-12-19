# -*- coding: utf-8 -*-

require 'spec_helper'

describe SettingController do

  context 'if NOT signed in' do
    describe "GET 'edit'" do
      it "returns http redirect to new user session" do
        get 'edit'
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "PUT 'update'" do
      it "returns http redirect to new user session" do
        put 'update'
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  context 'if signed in' do

    before :each do
      user_sign_in
      @user.updated_at = Time.now - 1.month
      @user.save
    end

    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit'
        response.should be_success
      end
    end

    describe "PUT 'update'" do
      it "returns http redirect to root path if not having objective" do
        put 'update', { user: { name: 'New Name' } }
        response.should redirect_to(root_path)
      end

      it "updates current_user" do
        put 'update', { user: { name: 'New Name' } }
        @user.reload
        @user.name.should == 'New Name'
      end

      it "returns http redirect to the same form if having objective" do
        objective = 'default'
        put 'update', { user: { name: 'New Name' }, objective: objective }
        location = edit_setting_objective_path(objective)
        response.should redirect_to(location)
      end
    end
  end
end
