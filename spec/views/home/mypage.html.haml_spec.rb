# -*- coding: utf-8 -*-

require 'spec_helper'

describe "home/mypage" do
  before :each do
    user_sign_in
  end

  it 'rendering works' do
    render template: 'home/mypage', layout: 'layouts/application'
  end
end
