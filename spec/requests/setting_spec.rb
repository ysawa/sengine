# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'Setting' do

  context 'if NOT signed in' do
    describe "edit" do
      it "returns http redirect" do
        get edit_setting_path
        response.should be_redirect
      end
    end
  end

  context 'if signed in' do
    before :each do
      @user = Fabricate(:user, name: 'User Name')
      user_sign_in_with_visit(@user, 'PASSWORD')
    end

    describe "edit" do
      it "works!" do
        visit edit_setting_path
      end
    end
  end
end
