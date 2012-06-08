# -*- coding: utf-8 -*-

require 'spec_helper'

describe "Home", type: :request do
  context 'without signing in' do
    describe "index" do
      it "works!" do
        get root_path
        response.status.should be(200)
      end
    end

    describe "mypage should NOT be rendered" do
      it "works!" do
        visit root_path
        page.should_not have_content 'Sign Out'
      end
    end
  end

  context 'with signing in' do
    before :each do
      @user = Fabricate(:user)
      user_sign_in_with_visit(@user, 'testtest')
    end

    describe "mypage should be rendered" do
      it "works!" do
        visit root_path
        page.should have_content 'Sign Out'
      end
    end
  end
end
