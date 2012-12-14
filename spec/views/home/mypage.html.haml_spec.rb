# -*- coding: utf-8 -*-

require 'spec_helper'

describe "home/mypage" do
  before :each do
    user_sign_in
  end

  it 'renders successfully' do
    render template: 'home/mypage', layout: 'layouts/application'
  end

  it 'renders successfully with games and comments' do
    @another = Fabricate(:user)
    @game = Fabricate(:game, author: @user, sente_user: @user, gote_user: @another)
    @comment = Fabricate(:comment, author: @another, commentable: @game)
    render template: 'home/mypage', layout: 'layouts/application'
  end
end
