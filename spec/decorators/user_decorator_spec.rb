require 'spec_helper'

describe UserDecorator do
  before :each do
    setup_controller_request
    @user = Fabricate(:user)
    @decorator = UserDecorator.new(@user)
  end

  describe '.image' do
    it 'make img tag of facebook' do
      image = @decorator.image
      image.should include '<img'
      image.should include 'noimage.gif'
    end

    it 'make img tag of facebook' do
      @user.facebook_id = 12345678
      image = @decorator.image
      image.should include '<img'
      image.should include '12345678'
    end
  end
end
