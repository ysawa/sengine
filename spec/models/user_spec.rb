# -*- coding: utf-8 -*-

require 'spec_helper'

describe User do

  describe '.bot?' do
    it 'should be false' do
      user = User.new
      user.bot?.should be_false
    end
  end

  describe '.content' do

    it 'has default value' do
      I18n.locale = :en
      user = User.new
      user.content.should == I18n.t('user.content.default', locale: :en)
      I18n.locale = :ja
      user = User.new
      user.content.should == I18n.t('user.content.default', locale: :ja)
    end
  end

  describe '.save' do
    let(:user) { User.new }

    context 'with invalid attributes' do
      it 'works!' do
        user.save.should be_false
      end
    end

    context 'with invalid attributes' do
      before :each do
        user.attributes = {
          email: 'test@leaping.jp',
          password: 'testtest',
          password_confirmation: 'testtest'
        }
      end

      it 'works!' do
        user.save.should be_true
      end
    end
  end

  describe '.authored_tags' do
    before :each do
      @user = Fabricate(:user)
      @tag = Fabricate(:tag)
    end

    it 'has authored tags' do
      @tag.author = @user
      @tag.save
      @user.authored_tags.to_a.should == [@tag]
    end
  end

  describe '.sente_games' do
    before :each do
      @user = Fabricate(:user)
    end

    it 'works!' do
      game = Game.new
      @user.sente_games << game
      @user = User.find(@user.id)
      @user.sente_games.should == [game]
    end
  end

  describe '.gote_games' do
    before :each do
      @user = Fabricate(:user)
    end

    it 'works!' do
      game = Game.new
      @user.gote_games << game
      @user = User.find(@user.id)
      @user.gote_games.should == [game]
    end
  end

  describe '.online? and .offline?' do
    before :each do
      @user = Fabricate(:user, email: 'test@example.com')
    end

    it 'shows which the user online or offline by used_at' do
      @user.used_at = nil
      @user.online?.should be_false
      @user.offline?.should be_true
      @user.used_at = Time.now
      @user.online?.should be_true
      @user.offline?.should be_false
      @user.used_at = Time.now - 1.minute - 1.second
      @user.online?.should be_false
      @user.offline?.should be_true
    end
  end

  describe '.setup_timezone' do
    before :each do
      @user = Fabricate(:user,
         timezone: nil,
         timezone_string: nil
      )
    end

    it 'initializes timezone from timezone string' do
      @user.timezone_string = 'Tokyo'
      @user.setup_timezone
      @user.timezone.should == 9
    end

    it "initializes timezone string 'Tokyo' from timezone (9)" do
      @user.timezone = 9
      @user.setup_timezone
      @user.timezone_string.should == 'Tokyo'
    end

    it 'initializes timezone string from timezone' do
      @user.timezone = 8
      @user.setup_timezone
      @user.timezone_string.should be_a String
      @user.timezone_string.should_not == 'Tokyo'
    end
  end

  describe 'callback of :set_admin_if_first_user' do
    before :each do
      User.delete_all
    end

    it 'the first user will be admin when created' do
      user = Fabricate(:user, email: 'test@example.com')
      user.admin.should be_true
    end

    it 'only the first user will be admin when created' do
      user = Fabricate(:user, email: 'test1@example.com')
      user = Fabricate(:user, email: 'test2@example.com')
      user.admin.should be_false
      user = Fabricate(:user, email: 'test3@example.com')
      user.admin.should be_false
    end
  end

  describe 'attr_protected' do
    before :each do
      @user = Fabricate(:user, admin: true)
    end

    attr_names = [:current_sign_in_ip, :encrypted_password, :facebook_access_token, :facebook_id, :facebook_username, :last_sign_in_ip, :reset_password_token]
    attr_names.each do |attr_name|
      it "protects #{attr_name}" do
        @user.update_attributes({ attr_name => 'New Attribute' })
        @user.reload
        @user.read_attribute(attr_name).should_not == 'New Attribute'
      end
    end

    attr_names = [:grade, :score, :sign_in_count]
    attr_names.each do |attr_name|
      it "protects #{attr_name}" do
        @user.update_attributes({ attr_name => 100 })
        @user.reload
        @user.read_attribute(attr_name).should_not == 100
      end
    end

    attr_names = [:admin]
    attr_names.each do |attr_name|
      it "protects #{attr_name}" do
        @user.update_attributes({ attr_name => false })
        @user.reload
        @user.read_attribute(attr_name).should_not == false
      end
    end

    attr_names = [:current_sign_in_at, :last_sign_in_at, :remember_created_at, :reset_password_sent_at, :used_at]
    attr_names.each do |attr_name|
      it "protects #{attr_name}" do
        time_now = Time.now
        @user.update_attributes({ attr_name => time_now })
        @user.reload
        @user.read_attribute(attr_name).should_not == time_now
      end
    end
  end
end
