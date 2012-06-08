# -*- coding: utf-8 -*-

require 'spec_helper'

describe "Help", type: :request do
  context 'without signing in' do
    describe "index" do
      it "works" do
        get help_path
        response.status.should be(200)
      end
    end
  end

  context 'with signing in' do
    before :each do
      @user = Fabricate(:user)
      user_sign_in_with_visit(@user, 'testtest')
    end

    context 'with locale set into ja' do
      describe "help should be rendered in Japanese" do
        before :each do
          @user.locale = 'ja'
          @user.save
        end

        it "works!" do
          visit help_path
          within 'h2' do
            page.should have_content 'ヘルプ'
          end
        end
      end
    end

    context 'with locale set into en' do
      describe "help should be rendered in English" do
        before :each do
          @user.locale = 'en'
          @user.save
        end

        it "works!" do
          visit help_path
          within 'h2' do
            page.should have_content 'Help'
          end
        end
      end
    end
  end
end
