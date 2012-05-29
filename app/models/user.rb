# -*- coding: utf-8 -*-

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  field :facebook_id, type: Integer
  field :facebook_username, type: String
  field :gender, type: String, default: 'male'
  field :locale, type: String, default: 'ja_JP'
  field :name, type: String, default: 'Unknown'
  field :timezone, type: Integer, default: 0

  has_many :sente_games, class_name: 'Game', inverse_of: :sente_user
  has_many :gote_games, class_name: 'Game', inverse_of: :gote_user
  has_many :created_games, class_name: 'Game', inverse_of: :author

  def games
    @games ||= Game.any_of({ 'sente_user_id' => id, 'gote_user_id' => id })
  end

  class << self
    def find_for_facebook_oauth(access_token, signed_in_resource=nil)
      data = access_token.extra.raw_info
      user = where(email: data.email).first
      unless user
        # Create a user with a stub password.
        user = create(:email => data.email, :password => Devise.friendly_token[0,20])
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
          user.gender = data["gender"]
        end
      end
    end
  end
end
