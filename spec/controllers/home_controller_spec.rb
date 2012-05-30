require 'spec_helper'

describe HomeController do

  context 'if NOT signed in' do
    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end

      it 'renders the top template' do
        get 'index'
        response.should render_template("top")
      end
    end
  end

  context 'if signed in' do

    before :each do
      user_sign_in
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end

      it 'renders the mypage template' do
        get 'index'
        response.should render_template("mypage")
      end
    end
  end
end
