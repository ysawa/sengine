# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'sessions' do

  before :each do
    @user = Fabricate(:user)
  end

  describe "signing in" do

    it "page can be accessed" do
      visit new_user_session_path
      page.should have_selector 'form#user_sign_in'
    end

    it "works successfully with correct password", js: true do
      user_sign_in_with_visit(@user, 'PASSWORD')
      page.should_not have_selector 'form#user_sign_in'
      page.should have_content I18n.t('pages.controllers.home.mypage')
    end

    it "fails with incorrect password", js: true do
      user_sign_in_with_visit(@user, 'BADPASSWORD')
      page.should have_selector 'form#user_sign_in'
      page.should_not have_content I18n.t('pages.controllers.home.mypage')
    end
  end
end
