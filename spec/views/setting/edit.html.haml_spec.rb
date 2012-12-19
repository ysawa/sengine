# -*- coding: utf-8 -*-

require 'spec_helper'

describe "setting/edit" do
  before :each do
    user_sign_in
  end

  it "renders successfully" do
    render
  end

  it 'renders nav tabs, but has no active tab' do
    render
    rendered.should have_selector 'ul.nav.nav-tabs li'
    rendered.should_not have_selector 'ul.nav.nav-tabs li.active'
  end

  context 'editing objective default' do
    before :each do
      @objective = 'default'
      assign(:objective, @objective)
    end

    it 'renders default form' do
      render
      rendered.should have_selector 'form.edit_user'
      rendered.should have_selector "input[name='user[name]']"
      rendered.should have_selector "textarea[name='user[content]']"
      rendered.should match @user.name
    end

    it 'renders the right objective field' do
      render
      rendered.should have_selector 'input[name="objective"][value="default"][type="hidden"]'
    end

    it 'renders nav tabs, but has active tab' do
      render
      rendered.should have_selector 'ul.nav.nav-tabs a'
      rendered.should have_selector 'ul.nav.nav-tabs li.active'
    end
  end

  context 'editing objective system' do
    before :each do
      @objective = 'system'
      assign(:objective, @objective)
    end

    it 'renders system form' do
      render
      rendered.should have_selector 'form.edit_user'
      rendered.should have_selector "select[name='user[locale]']"
      rendered.should have_selector "select[name='user[timezone_string]']"
      rendered.should have_selector "input[name='user[audio_on]']"
    end

    it 'renders the right objective field' do
      render
      rendered.should have_selector 'input[name="objective"][value="system"][type="hidden"]'
    end

    it 'renders nav tabs, but has active tab' do
      render
      rendered.should have_selector 'ul.nav.nav-tabs a'
      rendered.should have_selector 'ul.nav.nav-tabs li.active'
    end
  end
end
