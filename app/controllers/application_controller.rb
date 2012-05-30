# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :make_subtitle
protected
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

  def set_locale
    locale = nil
    if user_signed_in?
      locale = current_user.locale.sub(/_.*$/, '')
    end
    locale ||= I18n.default_locale
    I18n.locale = locale
  end

  def set_timezone
    timezone = nil
    if user_signed_in?
      timezone = current_user.timezone
    end
    timezone ||= Time.zone_default
  end
end
