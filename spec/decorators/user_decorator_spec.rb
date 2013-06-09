require 'spec_helper'

describe UserDecorator do
  before :each do
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

  describe '#audio_on' do
    it 'generate audio is ON/OFF' do
      @user.audio_on = true
      on_or_off = @decorator.audio_on
      on_or_off.should == 'ON'
      @user.audio_on = false
      on_or_off = @decorator.audio_on
      on_or_off.should == 'OFF'
    end
  end

  describe '#games_count' do
    it 'generate the number of games' do
      @decorator.games_count.should == 0
    end
  end

  describe '#gender' do
    it 'generate the gender that can be read by human' do
      @user.gender = 'male'
      @decorator.gender.should == I18n.t('user.genders.male')
      @user.gender = 'female'
      @decorator.gender.should == I18n.t('user.genders.female')
    end
  end

  describe '#online' do
    it 'generate online is ON/OFF' do
      @user.used_at = Time.now - 10.year
      @decorator.online.should == 'Offline'
      @user.used_at = Time.now
      @decorator.online.should == 'Online'
    end
  end
end
