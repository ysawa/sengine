require 'spec_helper'

describe "Feedbacks" do
  before :each do
    @current_user = Fabricate(:user)
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
    end
  end

  context 'if NOT signed in' do
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
    end
  end
end
