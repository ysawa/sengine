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

  has_many :sente_games, class_name: 'Game', inverse_of: :sente_user
  has_many :gote_games, class_name: 'Game', inverse_of: :gote_user
  has_many :created_games, class_name: 'Game', inverse_of: :author

  def games
    @games ||= Game.any_of({ 'sente_user_id' => id, 'gote_user_id' => id })
  end

  class << self
    def find_for_facebook_oauth(access_token, signed_in_resource=nil)
      data = access_token.extra.raw_info
      if user = where(email: data.email).first
        user
      else # Create a user with a stub password.
        create(:email => data.email, :password => Devise.friendly_token[0,20])
      end
    end

    def new_with_session(params, session)
      tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"]
        end
      end
    end
  end
end
