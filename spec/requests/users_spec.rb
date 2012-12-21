# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'users' do

  before :each do
    @user = Fabricate(:user)
  end

  context 'signing in' do
    before :each do
    end

    describe "accessing /users/sign_in" do

      it "page can be accessed" do
        visit new_user_session_path
        page.should have_selector 'form#user_sign_in'
      end

      it "works successfully with correct password", js: true do
        user_sign_in_with_visit(@user, 'PASSWORD')
        page.should have_content I18n.t('pages.controllers.home.mypage')
      end

      it "fails with incorrect password", js: true do
        user_sign_in_with_visit(@user, 'BAD PASSWORD')
        page.should have_selector 'form#user_sign_in'
      end
    end
  end
end
