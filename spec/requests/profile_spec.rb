# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'Profile' do

  before :each do
    @opponent = Fabricate(:user, name: 'opponent')
  end

  context 'if NOT signed in' do
    describe "show" do
      it "returns http redirect" do
        get profile_path(@opponent.id.to_s)
        response.should be_redirect
      end
    end
  end

  context 'if signed in' do
    before :each do
      @user = Fabricate(:user)
      user_sign_in_with_visit(@user, 'PASSWORD')
      @opponent = Fabricate(:user, name: 'Opponent Name')
    end

    describe "show" do
      it "works!" do
        visit profile_path(@opponent.id.to_s)
        page.should have_content @opponent.name
      end
    end
  end
end
