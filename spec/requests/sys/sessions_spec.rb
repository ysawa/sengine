# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'sessions to /sys' do

  before :each do
    @admin = Fabricate(:user, admin: true)
    @not_admin = Fabricate(:user, admin: false)
  end

  context 'if you are not admin,' do
    before :each do
      @user = @not_admin
      user_sign_in_with_visit(@user, 'PASSWORD')
    end

    describe "accessing /sys pages" do

      it "does not work." do
        visit sys_root_path
        page.should_not have_selector('body.admin')
      end
    end
  end

  context 'if you are admin,' do
    before :each do
      @user = @admin
      user_sign_in_with_visit(@user, 'PASSWORD')
    end

    describe "accessing /sys pages" do

      it "works." do
        visit sys_root_path
        page.should have_selector('body.admin')
      end
    end
  end
end
