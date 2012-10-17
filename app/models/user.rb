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
  field :birth, type: Date
  field :current_sign_in_at, type: Time
  field :current_sign_in_ip, type: String
  field :email, type: String
  field :encrypted_password, type: String
  field :facebook_access_token, type: String
  field :facebook_id, type: Integer
  field :facebook_username, type: String
  field :gender, type: String
  field :grade, type: Integer, default: 0
  field :grade_increased, type: Boolean, default: false
  field :last_sign_in_at, type: Time
  field :last_sign_in_ip, type: String
  field :locale, type: String, default: 'en'
  field :name, type: String
  field :remember_me, type: Boolean
  field :remember_created_at, type: Time
  field :score, type: Integer, default: 0
  field :score_differential, type: Integer
  field :sign_in_count, type: Integer
  field :themes, type: Array, default: []
  field :timezone, type: Integer, default: 9
  field :timezone_string, type: String
  field :used_at, type: Time

  has_many :sente_games, class_name: 'Game', inverse_of: :sente_user
  has_many :gote_games, class_name: 'Game', inverse_of: :gote_user
  has_many :won_games, class_name: 'Game', inverse_of: :won_user
  has_many :lost_games, class_name: 'Game', inverse_of: :lost_user
  has_many :created_games, class_name: 'Game', inverse_of: :author

  attr_protected :admin, :current_sign_in_at, :current_sign_in_ip, :encrypted_password, :facebook_access_token, :facebook_id, :facebook_username, :grade, :last_sign_in_at, :last_sign_in_ip, :remember_created_at, :score, :sign_in_count

  after_validation :setup_name
  after_validation :setup_timezone
  before_create :set_admin_if_first_user

  def create_facebook_feed(message, options = {})
    if facebook_access_token?
      url = "https://graph.facebook.com/me/feed?access_token=#{self.facebook_access_token}"
      post_options = options.stringify_keys
      post_options.reverse_merge!({ 'message' => message })
      client = HTTPClient.new
      client.post_content(url, post_options)
    end
  rescue => e
    p e
  end

  def facebook_birth=(date)
    if date.present?
      date =~ %r|(\d+)/(\d+)/(\d+)|
      month, day, year = $1, $2, $3
      date = Date.new(year.to_i, month.to_i, day.to_i)
    end
    self.birth = date
  end
  alias facebook_birth birth

  def find_facebook_friends(limit = 100, page = 0, recursive = false)
    return [] if self.facebook_access_token.blank?
    friend_maps = []
    url = "https://graph.facebook.com/me/friends?access_token=#{self.facebook_access_token}"
    if limit
      url += "&limit=#{limit}"
      if page
        url += "&offset=#{limit * page}"
      end
    end
    client = HTTPClient.new
    while true
      response = JSON.parse client.get_content(url)
      break if response["data"].blank?
      friend_maps += response["data"]
      if recursive && defined?(response['paging']['next'])
        url = response["paging"]['next']
      else
        break
      end
    end
    friend_maps
  end

  def find_facebook_friend_ids(limit = 100, page = 0, recursive = false)
    facebook_ids = []
    while true
      friend_maps = find_facebook_friends(limit, page, false)
      facebook_ids += friend_maps.collect { |map| map['id'] }
      break unless recursive
    end
    facebook_ids
  end

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
    if self.timezone? && self.timezone_string.blank?
      self.timezone_string = ActiveSupport::TimeZone[9].name
    end
    nil
  end

  def write_grade_with_score(score)
    past_grade = self.grade
    self.score_differential = score - self.score
    self.score = score
    self.grade = ScoreCalculator.score_to_grade(self.score)
    if past_grade < self.grade
      self.grade_increased = true
    end
    self.grade
  end

  class << self
    def facebook_friends(member)
      crit = criteria
      crit = crit.where(:_id.ne => member.id)
      if Rails.env.production?
        crit = crit.where(:facebook_id.in => member.find_facebook_friend_ids)
      end
      crit
    end

    # find or initialize user with data from facebook
    def find_for_facebook_oauth(access_token, signed_in_resource=nil)
      data = access_token.extra.raw_info
      user = where(email: data.email).first
      unless user
        # Create a user with a stub password.
        user = new(:email => data.email, :password => Devise.friendly_token[0,20])
      end
      user.facebook_id = data.id
      user.facebook_access_token = access_token.credentials.token
      user.facebook_username = data.username
      user.name ||= data.name
      user.locale ||= data.locale
      user.timezone ||= data.timezone
      user.gender ||= data.gender
      user.facebook_birth ||= data.birthday
      user.save
      user
    end
  end
private

  def set_admin_if_first_user
    self.admin = (User.count == 0)
    nil
  end
end
