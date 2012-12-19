# -*- coding: utf-8 -*-

require 'spec_helper'

describe "setting/edit" do
  before :each do
    user_sign_in
  end

  it "renders successfully" do
    render
  end

  context 'editing objective default' do
    before :each do
      @objective = 'default'
      assign(:objective, @objective)
    end

    it 'renders default form' do
      render
      rendered.should have_selector 'form.edit_user'
      rendered.should match @user.name
    end
  end
end
