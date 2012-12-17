# -*- coding: utf-8 -*-

require 'spec_helper'

describe "devise/registrations/new.html.haml" do
  before :each do
    @user = Fabricate(:user)
    view.stub!(:resource).and_return(User.new)
    view.stub!(:resource_name).and_return('user')
    view.stub!(:resource_class).and_return(User)
    view.stub!(:devise_mapping).and_return(Devise.mappings[:user])
  end

  it 'renders successfully.' do
    render
    rendered.should have_selector 'form#new_user'
    assert_select 'form#new_user' do
      assert_select "input[name='user[email]']"
      assert_select "input[name='user[password]']"
    end
  end
end
