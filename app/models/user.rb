# -*- coding: utf-8 -*-

require 'score_calculator'
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  field :admin, type: Boolean, default: false
  field :audio_on, type: Boolean, default: true
  field :current_sign_in_at, type: Time
  field :current_sign_in_ip, type: String
  field :email, type: String
  field :encrypted_password, type: String
  field :facebook_id, type: Integer
  field :facebook_username, type: String
  field :gender, type: String
  field :grade, type: Integer, default: 0
  field :last_sign_in_at, type: Time
  field :last_sign_in_ip, type: String
  field :locale, type: String, default: 'en'
  field :name, type: String
  field :remember_me, type: Boolean
  field :remember_created_at, type: Time
  field :score, type: Integer, default: 0
  field :sign_in_count, type: Integer
  field :themes, type: Array, default: []
  field :timezone, type: Integer, default: 9
  field :timezone_string, type: Integer
  field :used_at, type: Time

  has_many :sente_games, class_name: 'Game', inverse_of: :sente_user
  has_many :gote_games, class_name: 'Game', inverse_of: :gote_user
  has_many :won_games, class_name: 'Game', inverse_of: :won_user
  has_many :lost_games, class_name: 'Game', inverse_of: :lost_user
  has_many :created_games, class_name: 'Game', inverse_of: :author

  attr_protected :admin, :current_sign_in_at, :current_sign_in_ip, :encrypted_password, :facebook_id, :facebook_username, :grade, :last_sign_in_at, :last_sign_in_ip, :remember_created_at, :score, :sign_in_count

  after_validation :setup_name
  after_validation :setup_timezone
  before_create :set_admin_if_first_user

  def games
    @games ||= Game.any_of({ 'sente_user_id' => id, 'gote_user_id' => id })
  end

  def offline?
    !(self.used_at && self.used_at >= Time.now - 1.minute)
  end

  def online?
    !offline?
  end

  def setup_name
    if self.name.blank? && self.email? && self.email_changed?
      self.name = self.email.sub(/@.*$/, '')
    end
    nil
  end

  def setup_timezone
    if self.timezone_string? && self.timezone_string_changed?
      self.timezone = ActiveSupport::TimeZone[self.timezone_string].utc_offset / 3600
    end
    nil
  end

  def write_score_with_grade(score)
    self.score = score
    self.grade = ScoreCalculator.score_to_grade(self.score)
  end

  class << self
    def find_for_facebook_oauth(access_token, signed_in_resource=nil)
      data = access_token.extra.raw_info
      user = where(email: data.email).first
      unless user
        # Create a user with a stub password.
        user = new(:email => data.email, :password => Devise.friendly_token[0,20])
      end
      user.facebook_id = data.id
      user.name = data.name
      user.facebook_username = data.username
      user.locale = data.locale
      user.timezone = data.timezone
      user.gender = data.gender
      user.save
      user
    end

    def new_with_session(params, session)
      tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.name = data["name"]
          user.facebook_id = data["id"]
          user.facebook_username = data["username"]
          user.email = data["email"]
          user.locale = data["locale"]
          user.timezone = data["timezone"]
          user.timezone_string = ActiveSupport::TimeZone[user.timezone].to_s.sub(/^.* /, '')
          user.gender = data["gender"]
        end
      end
    end
  end
private

  def set_admin_if_first_user
    self.admin = (User.count == 0)
    nil
  end
end
