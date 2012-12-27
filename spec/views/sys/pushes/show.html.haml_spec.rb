# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/pushes/show.html.haml" do

  before :each do
    @push = Fabricate(:push)
    assign(:push, @push)
  end

  it 'renders successfully' do
    render
  end

  describe 'hidden_users' do
    before :each do
      @users = []
      10.times do |i|
        user = Fabricate(:user, name: "User_#{i}")
        @push.hide_user(user)
        @users << user
      end
    end

    it 'shows hidden users' do
      render
      @users.each do |user|
        rendered.should have_content user.name
      end
    end
  end
end
