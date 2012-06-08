# -*- coding: utf-8 -*-

require 'spec_helper'

describe "About", type: :request do
  context 'without signing in' do
    describe "game" do
      it "works" do
        get about_game_path
        response.status.should be(200)
      end
    end

    describe "us" do
      it "works" do
        get about_us_path
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
      describe "explanation should be rendered in Japanese" do
        before :each do
          @user.locale = 'ja'
          @user.save
        end

        describe "game" do
          it "works!" do
            visit about_game_path
            within 'h2' do
              page.should have_content "このゲームについて"
            end
          end
        end

        describe "us" do
          it "works!" do
            visit about_us_path
            within 'h2' do
              page.should have_content "運営者情報"
            end
          end
        end
      end
    end

    context 'with locale set into en' do
      describe "explanation should be rendered in English" do
        before :each do
          @user.locale = 'en'
          @user.save
        end

        describe "game" do
          it "works!" do
            visit about_game_path
            within 'h2' do
              page.should have_content 'About This Game'
            end
          end
        end

        describe "us" do
          it "works!" do
            visit about_us_path
            within 'h2' do
              page.should have_content 'About Us'
            end
          end
        end
      end
    end
  end
end
