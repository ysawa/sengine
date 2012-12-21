# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'Setting' do

  context 'if NOT signed in' do
    describe "edit" do
      it "returns http redirect" do
        get edit_setting_path
        response.should redirect_to(new_user_session_path)
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

    context 'objective is default' do
      before :each do
        @objective = 'default'
      end

      describe "edit" do
        it "renders form to edit basic information" do
          visit edit_setting_path(objective: @objective)
          page.should have_selector "input[name='user[name]']"
          page.should have_selector "textarea[name='user[content]']"
        end
      end
    end

    context 'objective is system' do
      before :each do
        @objective = 'system'
      end

      describe "edit" do
        it "renders form to edit information for system" do
          visit edit_setting_path(objective: @objective)
          page.should have_selector "input[name='user[audio_on]']"
        end
      end
    end
  end
end
