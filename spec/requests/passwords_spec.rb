# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'passwords' do

  def submit_button
    click_button I18n.t('helpers.submit.send_me_reset_password_instructions')
  end

  before :each do
    @user = Fabricate(:user)
    @another = Fabricate(:user)
  end

  describe "signing in" do

    it "page can be accessed" do
      visit new_user_password_path
      page.should have_selector 'form#edit_user'
      page_should_have_subtitle I18n.t('helpers.submit.send_me_reset_password_instructions')
    end

    it "user password can be reset" do
      @user.reset_password_token.should be_blank
      @user.reset_password_sent_at.should be_blank
      visit new_user_password_path
      within 'form#edit_user' do
        fill_in 'user_email', with: @user.email
        submit_button
      end
      @user.reload
      @user.reset_password_token.should_not be_blank
      @user.reset_password_sent_at.should_not be_blank
      @another.reload
      @another.reset_password_token.should be_blank
      @another.reset_password_sent_at.should be_blank
    end

    it "instruction can be sent" do
      mail_should_be_sent 1
      visit new_user_password_path
      within 'form#edit_user' do
        fill_in 'user_email', with: @user.email
        submit_button
      end
      mail_should_be_sent 2
    end
  end
end
