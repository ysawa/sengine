# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector
  protect_from_forgery
  before_filter :set_top_page_as_false
  before_filter :set_locale
  before_filter :set_timezone
  before_filter :make_subtitle
  after_filter :save_current_user_if_signed_in
protected

  def accepted_languages
    # no language accepted
    return [] if request.env["HTTP_ACCEPT_LANGUAGE"].nil?

    # parse Accept-Language and get accepted locales
    accepted = request.env["HTTP_ACCEPT_LANGUAGE"].split(",")
    accepted = accepted.map { |l| l.strip.split(";") }
    accepted = accepted.map { |l|
      if (l.size == 2)
        # quality present
        [l[0].split("-")[0].downcase, l[1].sub(/^q=/, "").to_f]
      else
        # no quality specified => quality == 1
        [l[0].split("-")[0].downcase, 1.0]
      end
    }

    # sort locales by quality
    accepted.sort { |l1, l2| l2[1] <=> l1[1] }
  end

  def authenticate_user!
    if check_if_facebook_crawler
      redirect_to root_path
    else
      super
    end
  end

  def check_if_facebook_crawler
    user_agent = request.env["HTTP_USER_AGENT"]
    user_agent =~ /^(facebookexternalhit|facebookplatform).*$/i
  end

  def load_facebook_token
    if session[:facebook_token].present?
      @facebook_token = session[:facebook_token]
    else
      @facebook_token = nil
    end
  end

  def make_notice(model_name, ref_name = nil, notice_now = false)
    ref_name ||= action_name
    notice_message = I18n.t("notices.#{ref_name}", model: model_name)
    if notice_now
      flash[:notice].now = notice_message
    else
      flash[:notice] = notice_message
    end
  end

  def make_subtitle(ref_name = nil)
    base_name = controller_path.gsub('/', '.')
    ref_name ||= action_name
    action_names = I18n.t("pages.controllers.#{base_name}")
    case action_names
    when Hash
      @subtitle = action_names[ref_name.to_sym]
    else
      @subtitle = nil
    end
  end

  def save_facebook_token(token)
    session[:facebook_token] = token.to_s
  end

  def save_current_user_if_signed_in
    if user_signed_in?
      current_user.used_at = Time.now
      current_user.save
    end
  end

  def select_locale_from_accepted_languages
    locales = accepted_languages
    selected = locales.find { |locale| Shogiengine::LOCALES.include? locale[0].to_sym }
    if selected
      selected[0]
    else
      nil
    end
  end

  def set_locale
    locale = nil
    user = user_signed_in? && current_user
    if user_signed_in? && current_user.persisted?
      locale = current_user.locale
    else
      locale = select_locale_from_accepted_languages
    end
    locale ||= I18n.default_locale
    locale = locale.to_s.sub(/_.*$/, '')
    I18n.locale = locale
  end

  def set_timezone
    timezone = nil
    if user_signed_in?
      if current_user.timezone_string?
        timezone = current_user.timezone_string
      else
        timezone = ActiveSupport::TimeZone[current_user.timezone]
      end
    end
    timezone ||= Time.zone_default
    Time.zone = timezone
  end

  def set_top_page_as_false
    @top_page = false
  end
end
