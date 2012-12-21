# -*- coding: utf-8 -*-

require 'spec_helper'

describe "Feedbacks" do
  before :each do
    @current_user = Fabricate(:user)
    # @not_published_not_success
    # @not_published_success
    # @published_not_success
    # @published_success
    [true, false].each do |published|
      [true, false].each do |success|
        feedback = Fabricate.build(:feedback)
        variable_name = "@"
        content = ""
        if published
          variable_name += "published"
          content += "Good Published"
          feedback.publish
        else
          variable_name += "not_published"
          content += "Not Published"
        end
        if success
          variable_name += "_success"
          content += ", Good Success"
        else
          variable_name += "_not_success"
          content += ", Not Success"
        end
        feedback.content = content
        feedback.success = success
        feedback.save
        instance_variable_set(variable_name, feedback)
      end
    end
  end

  context 'if NOT signed in' do
    describe "accessing /feedbacks" do
      it "can be accessed" do
        visit feedbacks_path
      end

      it "renders no form" do
        visit feedbacks_path
        page.should_not have_selector 'form.edit_feedback'
      end

      it "renders feedbacks unsuccess list" do
        visit feedbacks_path
        within('#feedbacks') do
          page.should_not have_content 'Good Published, Good Success'
          page.should have_content 'Good Published, Not Success'
          page.should_not have_content 'Not Published, Good Success'
          page.should_not have_content 'Not Published, Not Success'
        end
      end
    end
  end

  context 'if signed in' do
    before :each do
      user_sign_in_with_visit(@current_user, 'PASSWORD')
    end

    describe "accessing /feedbacks" do
      it "can be accessed" do
        visit feedbacks_path
      end

      it "renders edit form" do
        visit feedbacks_path
        page.should have_selector 'form.edit_feedback'
      end

      it "renders feedbacks unsuccess list" do
        visit feedbacks_path
        within('#feedbacks') do
          page.should_not have_content 'Good Published, Good Success'
          page.should have_content 'Good Published, Not Success'
          page.should_not have_content 'Not Published, Good Success'
          page.should_not have_content 'Not Published, Not Success'
        end
      end

      it "form cannot be submit without content", js: true do
        visit feedbacks_path
        within('form.edit_feedback') do
          fill_in 'feedback[content]', with: ''
          click_on I18n.t('helpers.submit.submit')
        end
        within('form.edit_feedback') do
          page.should have_selector('label.error', visible: true)
        end
      end

      it "form can be submit with content" do
        visit feedbacks_path
        within('form.edit_feedback') do
          fill_in 'feedback[content]', with: 'New Content'
          click_on I18n.t('helpers.submit.submit')
        end
        within('#feedbacks') do
          page.should have_content 'New Content'
        end
      end
    end

    describe "accessing /feedbacks/success" do
      it "can be accessed" do
        visit success_feedbacks_path
      end

      it "renders edit form" do
        visit success_feedbacks_path
        page.should have_selector 'form.edit_feedback'
      end

      it "renders feedbacks success list" do
        visit success_feedbacks_path
        within('#feedbacks') do
          page.should have_content 'Good Published, Good Success'
          page.should_not have_content 'Good Published, Not Success'
          page.should_not have_content 'Not Published, Good Success'
          page.should_not have_content 'Not Published, Not Success'
        end
      end

      it "form can be submit with content" do
        visit success_feedbacks_path
        within('form.edit_feedback') do
          fill_in 'feedback[content]', with: 'New Content'
          click_on I18n.t('helpers.submit.submit')
        end
        within('#feedbacks') do
          page.should have_content 'New Content'
        end
      end
    end
  end
end
