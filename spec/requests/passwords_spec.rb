# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'passwords' do

  before :each do
    @user = Fabricate(:user)
  end

  describe "signing in" do

    it "page can be accessed" do
      visit new_user_password_path
      page.should have_selector 'form#edit_user'
      page_should_have_subtitle I18n.t('helpers.submit.send_me_reset_password_instructions')
    end
  end
end
