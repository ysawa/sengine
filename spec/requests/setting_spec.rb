# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'Setting' do

  context 'if NOT signed in' do
    describe "show" do
      it "returns http redirect" do
        get setting_path
        response.should be_redirect
      end
    end
  end

  context 'if signed in' do
    before :each do
      @user = Fabricate(:user, name: 'User Name')
      user_sign_in_with_visit(@user, 'testtest')
    end

    describe "show" do
      it "works!" do
        visit setting_path
        page.should have_content @user.name
      end
    end
  end
end
